Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3KUU6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:58:37 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36328 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3KUU6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:58:34 -0500
Date: Thu, 21 Nov 2013 21:59:11 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915, fbdev: Fix Kconfig typo
Message-ID: <20131121205911.GP27344@phenom.ffwll.local>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
References: <1385044195-13318-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385044195-13318-1-git-send-email-bp@alien8.de>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 03:29:55PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Too many t's.
> 
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Borislav Petkov <bp@suse.de>

Queued for -next, thanks for the patch.
-Daniel
> ---
>  drivers/gpu/drm/i915/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
> index 6199d0b5b958..7ca35ecfd952 100644
> --- a/drivers/gpu/drm/i915/Kconfig
> +++ b/drivers/gpu/drm/i915/Kconfig
> @@ -43,7 +43,7 @@ config DRM_I915_KMS
>  	  like intelfb.
>  
>  config DRM_I915_FBDEV
> -	bool "Enable legacy fbdev support for the modesettting intel driver"
> +	bool "Enable legacy fbdev support for the modesetting intel driver"
>  	depends on DRM_I915
>  	select DRM_KMS_FB_HELPER
>  	select FB_CFB_FILLRECT
> -- 
> 1.8.4
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
