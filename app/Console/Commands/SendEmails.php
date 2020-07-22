<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Mail\DailyReport;
use Illuminate\Support\Facades\Mail;

class SendEmails extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'email:report {user=ashleylai58@gmail.com}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Send report email to a user';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        Mail::to($this->argument('user'))->send(new DailyReport);
        return 0;
    }
}
