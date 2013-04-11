Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149Ab3DKRwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:52:34 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:40690 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931Ab3DKRwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:52:33 -0400
Date: Thu, 11 Apr 2013 19:52:21 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Tomas Melin <tomas.melin@iki.fi>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: don't check inconsistent modeset
 state when force-restoring
Message-ID: <20130411175220.GC2482@netboy>
References: <20130409172820.GC27612@phenom.ffwll.local>
 <1365537090-11518-1-git-send-email-daniel.vetter@ffwll.ch>
 <20130410115901.GA4502@netboy>
 <20130410120724.GJ27612@phenom.ffwll.local>
 <20130410172717.GA2480@netboy>
 <CAKMK7uGTqSdq_V=Pu-BGNhhTqOn=fz5-LvUXBXpGQJqzL1QOUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uGTqSdq_V=Pu-BGNhhTqOn=fz5-LvUXBXpGQJqzL1QOUQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:03:25PM +0200, Daniel Vetter wrote:
 
> That patch should crash at all, so this is not expected. Can you pls
> check whether plain drm-intel-nightly is broken, too?

I did try drm-intel-nightly just now (1dd83e3), and it also freezes
the machine. I first verified that the power button shutdown is
working (before starting X). Then, with X running, closing and
reopening the lid results in a blank screen (no backlight) and a
seemingly frozen box.
 
> I'll quickly port the patch (in it's latest v3 version) to 3.9-rc
> kernels for you to test.

Okay, I'll try this next.

Thanks,
Richard
