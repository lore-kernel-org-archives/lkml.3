Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaBHS57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 13:57:59 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:43606 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbaBHS56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 13:57:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAMVG2stJPQhdmhVDJY8a93xjAWUtNptBbTv=KhAswBNfE+ECYA@mail.gmail.com>
References: <CAMVG2suzT1vphjHAUFCsbVBsd22U69jzQaKVwnEyGLBu6eGOSw@mail.gmail.com>
	<CAKb7Uvh8jPNcXAfVYkdC3y0wQ7icc52Cid_fN5bpvdBf12KPag@mail.gmail.com>
	<CAMVG2stJPQhdmhVDJY8a93xjAWUtNptBbTv=KhAswBNfE+ECYA@mail.gmail.com>
Date: Sat, 8 Feb 2014 13:57:57 -0500
X-Google-Sender-Auth: RY6JlxeqGwJS9koWkzuq6HTbprw
Message-ID: <CAKb7Uvh=SQVhxOVEf5bFqhbiythcH4S+xP4OsXjF0xCsVjVk0Q@mail.gmail.com>
Subject: Re: nouveau graphical corruption in 3.13.2
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Daniel J Blueman <daniel@quora.org>
Cc: "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 8, 2014 at 10:38 AM, Daniel J Blueman <daniel@quora.org> wrote:
> Interestingly, there was graphical failure booting 3.6.11, even
> nvidia-current fails to initialise, but these two issues could be due
> to running the Xorg stack in Ubuntu 14.04 pre-release. Using
> nouveau.noaccel=1 works great for the first X session, but after
> logging out, lightdm and the next session experiences this consistent
> screen corruption:
>
> http://quora.org/nouveau-corruption.jpg

Does that just happen in 3.6.11 or even in 3.13? If the latter, that
points to some key lack of understanding of... something. With
noaccel, we're not using pgraph or anything fancy -- it's just a
framebuffer, basically. So if we can't even render _that_ right...

Hopefully someone else will pipe up re your other issues -- my
knowledge base on this is exhausted :(

  -ilia
