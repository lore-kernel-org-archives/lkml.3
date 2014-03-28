Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbaC1IsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:48:24 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64037 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaC1IsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:48:12 -0400
Date: Fri, 28 Mar 2014 09:48:05 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm fixes
Message-ID: <20140328084805.GE22327@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	DRI mailing list <dri-devel@lists.freedesktop.org>
References: <alpine.DEB.2.00.1403280242370.28928@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1403280242370.28928@skynet.skynet.ie>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 02:46:11AM +0000, Dave Airlie wrote:
> 
> Hi Linus,
> 
> didn't want these to wait for stable cycle, the nouveau and radeon ones
> are the same problem, where the runtime pm stuff broke non-runtime pm 
> managed secondary GPUs, udl is an oops on unplug, and i915 is a regression 
> fix on Sandybridge even though it may break haswell (regression wins).

My apologies for the i915 regression fumble, that thing somehow fell
through the cracks here for almost half a year :( Imo that's more than
enough flailing to just go ahead with the revert, and the re-broken hsw
should get peoples attention ...
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
