Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3GAJDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:03:18 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:63439 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3GAJDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:03:16 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKMK7uFzwiztE8H1rvSDWQmw08JGoKdnTs5BYqxdrHwb=pK50A@mail.gmail.com>
References: <CA+icZUXyizuCR3YDfFXD5hCkgycFYGzMHaJxg=m9UackT7uzGQ@mail.gmail.com>
	<CAKMK7uFzwiztE8H1rvSDWQmw08JGoKdnTs5BYqxdrHwb=pK50A@mail.gmail.com>
Date: Mon, 1 Jul 2013 11:03:14 +0200
Message-ID: <CA+icZUXnHaT75NhhSx+AhcMEKybHugH9+hV_mS5h5-cimFdz6A@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 1 [ drm-intel-next: Several call-traces ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: "Barnes, Jesse" <jbarnes@virtuousgeek.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        DRI <dri-devel@lists.freedesktop.org>, Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 10:52 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Mon, Jul 1, 2013 at 10:49 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Mon, Jul 1, 2013 at 9:59 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi all,
>>>
>>> Changes since 20130628:
>>>
>>> The regulator tree gained a build failure so I used the version from
>>> next-20130628.
>>>
>>> The trivial tree gained a conflict against the fbdev tree.
>>>
>>> The arm-soc tree gained a conflict against the net-next tree.
>>>
>>> The akpm tree lost a few patches that turned up elsewhere and I removed 2
>>> that were causing run time problems.
>>>
>>
>> [ CC drm and drm-intel folks ]
>>
>> [ Did not check any relevant MLs ]
>>
>> Please, see attached dmesg output.
>
> Clock mismatch, one for Jesse to figure out. Note that this patch is
> for 3.12, I simply haven't yet gotten around to properly split my
> patch queue so a few spilled into -next. I'll do that now.

I like lightspeed-fast replies :-).

Guess "drm/i915: get mode clock when reading the pipe config v9" [1]
is the cause.

- Sedat -

[1] http://cgit.freedesktop.org/~danvet/drm-intel/commit/?h=drm-intel-next-queued&id=d325d8b4f351f9d45e7c8baabf581fd21f343133

> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
