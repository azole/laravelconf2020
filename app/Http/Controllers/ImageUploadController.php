<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Image;

class ImageUploadController extends Controller
{
    public function upload(Request $request)
    {
        $image = new Image;

        $image->name = time() . '.' .  $request->image->extension();
        $image->path = $request->file('image')->storeAs('images', $image->name, 'public');

        $image->save();

        return back()
            ->with('success', '上傳成功')
            ->with('image', asset('storage/' . $image->path));
    }

    public function list()
    {
        $images = Image::latest()->take(5)->get();

        return view('images', ['images' => $images]);
    }
}
