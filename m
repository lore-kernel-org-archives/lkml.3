Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaKGJN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:13:57 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:45440 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaKGJNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:13:52 -0500
Date: Fri, 7 Nov 2014 10:06:36 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Alex Pilon <alp+linux@alexpilon.ca>
Cc: David Airlie <airlied@linux.ie>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: Fix spelling.
Message-ID: <20141107090636.GK26941@phenom.ffwll.local>
Mail-Followup-To: Alex Pilon <alp+linux@alexpilon.ca>,
	David Airlie <airlied@linux.ie>, trivial@kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20141107003505.GA3491@alexpilon.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107003505.GA3491@alexpilon.ca>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 07:36:03PM -0500, Alex Pilon wrote:
> Fix spelling of 'ioctl'.
> 
> Signed-off-by: Alex Pilon <alp+linux@alexpilon.ca>
> ---
>  drivers/gpu/drm/drm_crtc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index e79c8d3..3d274c1 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -2943,7 +2943,7 @@ EXPORT_SYMBOL(drm_mode_legacy_fb_format);
>   * @file_priv: drm file for the ioctl call
>   *
>   * Add a new FB to the specified CRTC, given a user request. This is the
> - * original addfb ioclt which only supported RGB formats.
> + * original addfb ioctl which only supported RGB formats.

I already have this one from a different person. When doing trivial
patches please always check with linux-next whether it's still valid.
Especially for drm where we have a few hundred patches per release.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
