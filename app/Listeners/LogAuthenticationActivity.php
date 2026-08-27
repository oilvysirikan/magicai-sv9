<?php

namespace App\Listeners;

use Illuminate\Auth\Events\Failed;
use Illuminate\Auth\Events\Login;
use Illuminate\Auth\Events\Logout;
use Illuminate\Auth\Events\Registered;
use Spatie\Activitylog\Facades\Activity;

/**
 * Audit-logs authentication events using spatie/laravel-activitylog.
 *
 * The listener is intentionally defensive: it does nothing unless the
 * activitylog package is actually installed, so removing/omitting the
 * package (or running before `composer require`) will never break auth.
 */
class LogAuthenticationActivity
{
    public function handle($event): void
    {
        if (! class_exists(Activity::class)) {
            return;
        }

        $user = $event->user ?? null;
        $email = $event->credentials['email'] ?? null;

        match (get_class($event)) {
            Login::class      => activity()->causedBy($user)->log('User logged in'),
            Logout::class     => activity()->causedBy($user)->log('User logged out'),
            Registered::class => activity()->causedBy($user)->log('User registered'),
            Failed::class     => activity()->withProperties(['email' => $email])->log('Failed login attempt'),
            default           => null,
        };
    }
}
