Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3IEWCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:02:10 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43886 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3IEWCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
	<CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
Date: Fri, 6 Sep 2013 08:02:06 +1000
Message-ID: <CAPM=9tyGiQ-yipeGHO0oOM71DnsiUdocwKXhseAMT8J00HdwCg@mail.gmail.com>
Subject: Re: [git pull] drm tree for 3.12-rc1
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 5:18 AM, Linus Torvalds
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
>
> Because my shiny new 65W haswell is really nice and does a "make
> allmodconfig" in half the time of my old machine, but the GPU side has
> been something of a step backwards...

Welcome to new Intel HW :-P

So did you reboot into the new kernel from the old, maybe try reproducing
but booting an old kernel and booting into the new one from it, it might
be some hw state getting left set across soft reset or something,

I'm hoping Intel guys pipe up on the other HSW issues, I only have
one HSW laptop with an eDP panel and no external outputs on the
Intel GPU.

Dave.
