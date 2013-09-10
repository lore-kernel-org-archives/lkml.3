Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3IJGZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:25:36 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:34215 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3IJGZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:25:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie> <CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
From: Sean V Kelley <sean.v.kelley@intel.com>
Date: Mon, 9 Sep 2013 23:25:13 -0700
Message-ID: <CA+qSnqh1X6_xHD4GX1P=acEUg9+0=3dVSZHm-NYXvCvupFB8_g@mail.gmail.com>
Subject: Re: [git pull] drm tree for 3.12-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 12:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Sep 5, 2013 at 3:41 AM, Dave Airlie <airlied@linux.ie> wrote:
>>
>> i915: Haswell PC8+ support and eLLC support, HDMI 4K support, initial per-process VMA pieces,
>>       watermark reworks, convert to generic hdmi infoframes, encoder reworking, fastboot support,
>
> Hmm.
>
> The first time I booted this, I just got a black screen on my Haswell
> desktop when X11 started up.  I could ctrl-alt-BS and ctrl-alt-del to
> reboot the machine, and neither the Xorg.0.log nor the dmesg contained
> anything interesting.
>
> I was about to try to bisect it, but decided to see how repeatable it
> was, and it didn't happen again. But it also hasn't ever happened
> before, so I'm a bit worried.
>
> This is with the DP cable, which has made my other Haswell issues go away.
>
> I'm also a bit bummed that hw acceleration of video doesn't seem to
> work on Haswell, meaning that full-screen is now a jerky mess. I fear
> that that is user-space libraries/X.org, but I thought I'd mention it
> in the hope of getting a "oh, it's working for us, you'll get a fix
> for it soon".

Linus,

Can you give a little more detail about video not working?  Video
accel should work fine with the current versions of libva/intel-driver
available in Fedora 19 - assuming that's what you're using.  I am
running that on my MacBook Air 2013 and  HSW based Asus quad core i7
desktop.   A quick way to exercise the decoders once you install
libva/intel-driver is to use VLC enabling GPU acceleration in
preferences.

Sean

>
> Because my shiny new 65W haswell is really nice and does a "make
> allmodconfig" in half the time of my old machine, but the GPU side has
> been something of a step backwards...
>
>                Linus
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Sean V. Kelley <sean.v.kelley@intel.com>
Open Source Technology Center / SSG
Intel Corp.
