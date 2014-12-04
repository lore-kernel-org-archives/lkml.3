Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbaLDSQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:16:56 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:62365 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaLDSQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:16:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAKMK7uHQzqqtg=HBDfyMdZbOGNuzaMz10XeDdCnxkta+R8Sv9Q@mail.gmail.com>
References: <1417533733-2289-1-git-send-email-daniel.vetter@ffwll.ch>
	<1417534582-2977-1-git-send-email-daniel.vetter@ffwll.ch>
	<20141202163506.GG18921@nuc-i3427.alporthouse.com>
	<CALAqxLUCD7zxyNrZJnKUE3wbORyZez-bDvScGLXyTjVvvZdinA@mail.gmail.com>
	<20141203143029.GF32117@phenom.ffwll.local>
	<CALAqxLUYL91khoW=oLAp_FtPBrDnSazfYqVpkXYTBJsTjDsv+g@mail.gmail.com>
	<20141204104228.GJ32117@phenom.ffwll.local>
	<CALAqxLX0hvv5DeLRji7g+jVX+F2ipU_f04YtehjFnSV4i==q4w@mail.gmail.com>
	<CAKMK7uHQzqqtg=HBDfyMdZbOGNuzaMz10XeDdCnxkta+R8Sv9Q@mail.gmail.com>
Date: Thu, 4 Dec 2014 10:16:54 -0800
Message-ID: <CALAqxLUGh=2LF4kvK231P7AbChUmXGsHVvsD2PQcM_SHPpGvyw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: compute wait_ioctl timeout correctly
From: John Stultz <john.stultz@linaro.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 9:50 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Thu, Dec 4, 2014 at 6:42 PM, John Stultz <john.stultz@linaro.org> wrote:
>> Sigh. So you're going to make me write a separate patch that moves it over?
>
> We've written it already, Imre posted the link to the old discussion:
>
> https://lkml.org/lkml/2013/5/10/187
>
> But if the first attempt doesn't sufficiently stick I tend to chase
> the patches any more. But if you want to resurrect this I could ping
> Imre and ask him to pick it up again or you could rebase his patches.

Well, last I saw the initial patch was buggy, no? I don't think I saw
it being resubmitted.


>> But still, I do see our change broke you here, so I'm not going to object.
>
> Ok, thanks I'll pull this in through drm-intel for 3.19 (3.18 is kinda
> done already I guess) with cc: stable.

You probably should submit it for 3.18 and let Linus decide if its too
late. I've already gotten yelled at by Ingo for pushing patches in the
merge window that cc stable. Even if its out of a desire to let the
patches get wider testing, its something of a hot-button item for
folks. :)

thanks
-john
