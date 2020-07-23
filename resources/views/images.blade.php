@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            @foreach($images as $image)
            <div class="card">
              <img src="{{ $image->path }}">
            </div>
            @endforeach
        </div>
    </div>
</div>
@endsection
