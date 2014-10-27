Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaJ0ORJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:17:09 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57746 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaJ0ORH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:17:07 -0400
Date: Mon, 27 Oct 2014 15:17:17 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Andrzej Hajda <a.hajda@samsung.com>, Dave Airlie <airlied@gmail.com>
Cc: dri-devel@lists.freedesktop.org, Thierry Reding <treding@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] MAINTAINERS: Add entry for MIPI DSI bus
Message-ID: <20141027141717.GN26941@phenom.ffwll.local>
Mail-Followup-To: Andrzej Hajda <a.hajda@samsung.com>,
	Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
	Thierry Reding <treding@nvidia.com>,
	open list <linux-kernel@vger.kernel.org>
References: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
 <1414403310-6316-2-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414403310-6316-2-git-send-email-a.hajda@samsung.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 10:48:26AM +0100, Andrzej Hajda wrote:
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dd31933..476679c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3071,6 +3071,13 @@ F:	drivers/gpu/vga/
>  F:	include/drm/
>  F:	include/uapi/drm/
>  
> +DRM MIPI DSI BUS
> +M:	Andrzej Hajda <a.hajda@samsung.com>
> +L:	dri-devel@lists.freedesktop.org
> +S:	Supported
> +F:	drivers/gpu/drm/drm_mipi_dsi.c
> +F:	include/drm/drm_mipi_dsi.h

I really prefer when common infrastructure like this doesn't get
maintainer by a vendor. And I care with my intel hat on since we also ahve
a dsi driver that sooner or later needs to be converted to to this stuff.

Why doesn't the usual model of merging stuff through Dave's tree, or if
that doesn't work well due to patch depencies, through vendor trees with
Dave's ack?

Thanks, Daniel

> +
>  RADEON DRM DRIVERS
>  M:	Alex Deucher <alexander.deucher@amd.com>
>  M:	Christian König <christian.koenig@amd.com>
> -- 
> 1.9.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
