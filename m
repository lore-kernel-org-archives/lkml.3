Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab3EDILH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 04:11:07 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:55366 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354Ab3EDIKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 04:10:36 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130504011836.GE8320@zod.gha.chartermi.net>
References: <alpine.DEB.2.00.1305030224580.12778@skynet.skynet.ie>
	<20130503143951.GB8320@zod.gha.chartermi.net>
	<CAKMK7uF46a87KDg=n-rLhq2kjuPCpexHGwfR9UcPc_smZjqQzg@mail.gmail.com>
	<20130503165720.GC8320@zod.gha.chartermi.net>
	<20130503203149.GD8320@zod.gha.chartermi.net>
	<CAKMK7uGO4cUByr3kTWF7po55B1qrZy_=P_EW0+6trBsq_fGtSA@mail.gmail.com>
	<20130504011836.GE8320@zod.gha.chartermi.net>
Date: Sat, 4 May 2013 10:10:35 +0200
Message-ID: <CAKMK7uHLt-=Mjph42kkvSN=M7Jvo-janZJzW1RK72Y0WwRR8jA@mail.gmail.com>
Subject: Re: [git pull] drm for 3.10-rc1
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 4, 2013 at 3:18 AM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Fri, May 03, 2013 at 10:40:17PM +0200, Daniel Vetter wrote:
>>On Fri, May 3, 2013 at 10:31 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>> OK.  Git bisect tells me this:
>>>
>>> 57c219633275c7e7413f8bc7be250dc092887458 is the first bad commit
>>> commit 57c219633275c7e7413f8bc7be250dc092887458
>>> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
>>> Date:   Thu Apr 4 17:19:37 2013 +0200
>>>
>>>     drm/i915: revert eDP bpp clamping code changes
>>
>>Yeah, that commit is a bit dubios and for 3.11 we've already planned
>>to kick it out. It tries to work around an issue on a funky
>>pre-release hw. Does reverting this commit fix your issue?
>
> Yes, seems so.  I reverted it on top of Linus tree as of commit
> ce857229e0c3adc2 and things boot normally on the machine after that.

Thanks for confirming, I've reverted the patch and will foward my
current drm-intel-fixes tree soon to Dave.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
