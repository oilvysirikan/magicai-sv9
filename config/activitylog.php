<?php

use Spatie\Activitylog\Models\Activity;

return [

    /*
     |--------------------------------------------------------------------------
     | Activity Model
     |--------------------------------------------------------------------------
     |
     | The model you want to use for activity logging.
     |
     */

    'activity_model' => Activity::class,

    /*
     |--------------------------------------------------------------------------
     | Automatically load activity
     |--------------------------------------------------------------------------
     |
     | If true, the `activities` relation will be loaded automatically when
     | fetching models that use the `LogsActivity` trait.
     |
     */

    'automatically_load_relations' => false,

    /*
     |--------------------------------------------------------------------------
     | Delete records older than days
     |--------------------------------------------------------------------------
     |
     | Activitylog will keep all records forever by default. Use this setting
     | to delete records older than the given amount of days.
     |
     */

    'delete_records_older_than_days' => 365,

    /*
     |--------------------------------------------------------------------------
     | Table name
     |--------------------------------------------------------------------------
     |
     | The name of the table used to store activities.
     |
     */

    'table_name' => env('ACTIVITYLOG_TABLE_NAME', 'activity_log'),

    /*
     |--------------------------------------------------------------------------
     | Database connection
     |--------------------------------------------------------------------------
     |
     | The database connection on which the activity log table resides.
     |
     */

    'database_connection' => env('ACTIVITYLOG_DATABASE_CONNECTION', null),

    /*
     |--------------------------------------------------------------------------
     | Default auth driver
     |--------------------------------------------------------------------------
     |
     | The auth driver used to resolve the causer of an activity.
     |
     */

    'default_auth_driver' => env('ACTIVITYLOG_DEFAULT_AUTH_DRIVER', null),

    /*
     |--------------------------------------------------------------------------
     | Subject returns soft deleted models
     |--------------------------------------------------------------------------
     */

    'subject_returns_soft_deleted_models' => false,

];
