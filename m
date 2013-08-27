Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3H0Jeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:34:46 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:42873 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3H0Jeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:34:44 -0400
Date: Tue, 27 Aug 2013 11:34:55 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, torvalds@linux-foundation.org, tglx@linutronix.de,
        hpa@zytor.com
Subject: Re: [Intel-gfx] Updated stolen mem patches
Message-ID: <20130827093454.GJ26909@phenom.ffwll.local>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	mingo@elte.hu, torvalds@linux-foundation.org, tglx@linutronix.de,
	hpa@zytor.com
References: <1374870772-4592-1-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374870772-4592-1-git-send-email-jbarnes@virtuousgeek.org>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 01:32:50PM -0700, Jesse Barnes wrote:
> These address the comments I've received so far, but omit the new E820
> type for this mem.
> 
> Chris's patches could go on top if desired; they add a new type and
> resource reservation function for looking up regions by name.  That
> allows us to remove some duplicate code in the driver for finding stolen
> space.
> 
> But I think these two are ready as-is.  How should we merge them?  Just
> through the i915 tree since the first one touches our headers?  that and
> there probably won't be conflicts on the early-quirks file; that's not
> touch too often...

Just noticed that these patches aren't in -next yet - somehow I've thought
they'd go in in through the x86 tree.

Ingo et al: Should I merge these through drm-intel-next or will you pick
them up?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
