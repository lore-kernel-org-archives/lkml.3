Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbaJWIMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:12:43 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44234 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaJWIMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:12:34 -0400
Date: Thu, 23 Oct 2014 10:12:42 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Masanari Iida <standby24x7@gmail.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH] gpu: drm: Fix warning caused by a parameter description
 in drm_crtc.c
Message-ID: <20141023081242.GB26941@phenom.ffwll.local>
Mail-Followup-To: Masanari Iida <standby24x7@gmail.com>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	corbet@lwn.net
References: <1414022788-32224-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414022788-32224-1-git-send-email-standby24x7@gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 09:06:28AM +0900, Masanari Iida wrote:
> This patch fix following error while "make xmldocs"
> 
> Warning(.//drivers/gpu/drm/drm_crtc.c:778): Excess function parameter
>  'mode' description in 'drm_connector_get_cmdline_mode'
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Thanks, picked up for my simple drm core patches queue.
-Daniel

> ---
>  drivers/gpu/drm/drm_crtc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index e79c8d3..171f9a5 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -766,7 +766,6 @@ static void drm_mode_remove(struct drm_connector *connector,
>  /**
>   * drm_connector_get_cmdline_mode - reads the user's cmdline mode
>   * @connector: connector to quwery
> - * @mode: returned mode
>   *
>   * The kernel supports per-connector configration of its consoles through
>   * use of the video= parameter. This function parses that option and
> -- 
> 2.1.2.451.g98349e5
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
