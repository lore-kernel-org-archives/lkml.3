Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab3CHFLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:11:09 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48667 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3CHFLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:11:07 -0500
Date: Thu, 7 Mar 2013 21:10:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jacob Shin <jacob.shin@amd.com>,
        linux-acpi@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 01/14] x86, ACPI, mm: Kill max_low_pfn_mapped
Message-ID: <20130308051059.GC14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
 <1362718720-27048-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362718720-27048-2-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:58:27PM -0800, Yinghai Lu wrote:
> diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
> index 69d97cb..7f9380b 100644
> --- a/drivers/gpu/drm/i915/i915_gem_stolen.c
> +++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
> @@ -81,7 +81,7 @@ static unsigned long i915_stolen_to_physical(struct drm_device *dev)
>  		base -= dev_priv->mm.gtt->stolen_size;
>  	} else {
>  		/* Stolen is immediately above Top of Memory */
> -		base = max_low_pfn_mapped << PAGE_SHIFT;
> +		base = __REMOVED_CRAZY__ << PAGE_SHIFT;

Huh?

-- 
tejun
