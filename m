Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3AaIgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:36:36 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:49604 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3AaIgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:36:33 -0500
Date: Thu, 31 Jan 2013 09:38:41 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Changlong Xie <changlongx.xie@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Ben Widawsky <ben@bwidawsk.net>,
        linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH drm-intel] drm/i915: gen6_gmch_remove can be static
Message-ID: <20130131083841.GC5885@phenom.ffwll.local>
Mail-Followup-To: Changlong Xie <changlongx.xie@intel.com>,
	Ben Widawsky <ben@bwidawsk.net>, linux-kernel@vger.kernel.org,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>
References: <20130131033250.GA113229@bee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131033250.GA113229@bee>
X-Operating-System: Linux phenom 3.8.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 11:32:50AM +0800, Changlong Xie wrote:
> Signed_off_by: Changlong Xie <changlongx.xie@intel.com>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>

Queued for -next, thanks for the patch. Note that checkpatch complained
about the _ instead of - in your sob line, fixed up while applying.
-Daniel

> ---
>  i915_gem_gtt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
> index 87249e8..748015b 100644
> --- a/drivers/gpu/drm/i915/i915_gem_gtt.c
> +++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
> @@ -773,7 +773,7 @@ static int gen6_gmch_probe(struct drm_device *dev,
>  	return ret;
>  }
>  
> -void gen6_gmch_remove(struct drm_device *dev)
> +static void gen6_gmch_remove(struct drm_device *dev)
>  {
>  	struct drm_i915_private *dev_priv = dev->dev_private;
>  	iounmap(dev_priv->gtt.gsm);

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
