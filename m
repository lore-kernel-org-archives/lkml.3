Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab3IETSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:18:34 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:63331 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3IETSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:18:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
Date: Thu, 5 Sep 2013 12:18:32 -0700
X-Google-Sender-Auth: WN6myMUJBkGgXzY2ErYzwYqIwLw
Message-ID: <CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
Subject: Re: [git pull] drm tree for 3.12-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 3:41 AM, Dave Airlie <airlied@linux.ie> wrote:
>
> i915: Haswell PC8+ support and eLLC support, HDMI 4K support, initial per-process VMA pieces,
>       watermark reworks, convert to generic hdmi infoframes, encoder reworking, fastboot support,

Hmm.

The first time I booted this, I just got a black screen on my Haswell
desktop when X11 started up.  I could ctrl-alt-BS and ctrl-alt-del to
reboot the machine, and neither the Xorg.0.log nor the dmesg contained
anything interesting.

I was about to try to bisect it, but decided to see how repeatable it
was, and it didn't happen again. But it also hasn't ever happened
before, so I'm a bit worried.

This is with the DP cable, which has made my other Haswell issues go away.

I'm also a bit bummed that hw acceleration of video doesn't seem to
work on Haswell, meaning that full-screen is now a jerky mess. I fear
that that is user-space libraries/X.org, but I thought I'd mention it
in the hope of getting a "oh, it's working for us, you'll get a fix
for it soon".

Because my shiny new 65W haswell is really nice and does a "make
allmodconfig" in half the time of my old machine, but the GPU side has
been something of a step backwards...

               Linus
