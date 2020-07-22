@component('mail::message')
# Laravel Conf Taiwan 2020



@component('mail::button', ['url' => 'https://laravelconf.tw/'])
Goto Conf
@endcomponent

Thanks,<br>
{{ config('app.name') }}
@endcomponent
