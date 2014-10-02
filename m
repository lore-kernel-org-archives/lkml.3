Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaJBI6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:58:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12925 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaJBI6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:58:47 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-bf-542d13c401d2
Message-id: <542D13CC.5000304@samsung.com>
Date: Thu, 02 Oct 2014 17:58:52 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.1.1
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/exynos: fix vblank handling during dpms off
References: <542B9A0E.7020206@samsung.com>
 <1412151287-12845-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1412151287-12845-1-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkUPeIsG6IwecP2ha31p1jteg9d5LJ
	4srX92wWk+5PYLHoXXCVzeJs0xt2i8u75rBZzDi/j8lixuSXbA6cHtu/PWD1uN99nMmjb8sq
	Ro/Pm+QCWKK4bFJSczLLUov07RK4MnZt+8BSsFam4tca5QbGJ+JdjJwcEgImErc3XWWBsMUk
	LtxbzwZiCwksZZR49cwMpubfl0WsXYxcQPHpjBKH555lgnBeM0q8Pv6BEaSKV0BLYlvDObBJ
	LAKqEt/fdYFNYhPQk7iz7ThQAweHqECYxN/b3BDlghI/Jt8DKxcR8JCY/2YPM8hMZoEmJomr
	zx4wgySEBVwkrk74zARxUYrEk99vwWxOoPifkx/BZjIDzb9/UQskzCwgL7F5zVuwORIC19gl
	rn5uY4O4R0Di2+RDLCD1EgKyEpsOMEM8JilxcMUNlgmMYrOQnDQLYeosJFMXMDKvYhRNLUgu
	KE5KLzLRK07MLS7NS9dLzs/dxAiMvdP/nk3YwXjvgPUhRgEORiUe3owGnRAh1sSy4srcQ4ym
	QEdMZJYSTc4HRnheSbyhsZmRhamJqbGRuaWZkjjva6mfwUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYxde0r+vP8dC68PrfXdsPKxWOOhiz9q47zSRfdfywV880D+39G5sLpkh9SOG9ct7r
	5/nT/95dL6xqKA1YOsdce2Ffx9oHef2mC9cyGBrqBXfHsPf8lhU8G/z760HJv0erHr8O79Tn
	Uv8sVMjC5aFXP82E4/Yv7in7crkND2l80q/5krWi5mGeEktxRqKhFnNRcSIACkmzV7gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jQd0jwrohBlvOq1jcWneO1aL33Ekm
	iytf37NZTLo/gcWid8FVNouzTW/YLS7vmsNmMeP8PiaLGZNfsjlwemz/9oDV4373cSaPvi2r
	GD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixa9sHloK1MhW/
	1ig3MD4R72Lk5JAQMJH492URK4QtJnHh3nq2LkYuDiGB6YwSh+eeZYJwXjNKvD7+gRGkildA
	S2JbwzkWEJtFQFXi+7suNhCbTUBP4s6240ANHByiAmESf29zQ5QLSvyYfA+sXETAQ2L+mz3M
	IDOZBZqYJK4+e8AMkhAWcJG4OuEzE4gtJJAi8eT3WzCbEyj+5+RHsJnMQPPvX9QCCTMLyEts
	XvOWeQKjwCwkK2YhVM1CUrWAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBsP5Pewbiq
	weIQowAHoxIPb0aDTogQa2JZcWXuIUYJDmYlEd4UXt0QId6UxMqq1KL8+KLSnNTiQ4ymQP9P
	ZJYSTc4Hpp28knhDYxMzI0sjc0MLI2NzJXHeg63WgUIC6YklqdmpqQWpRTB9TBycUg2MktHL
	3fKOxeq7Chc62Uk/OKC9WnBz8wLBBwEKG5Vl+iqKU4KUK4y4g0oMdmWIOr2bu+d2o9k5FpNG
	btcmGb5T82ue5pW4+C4Vamta/3uTrtv69z5/Vc/cqX9d/Ey6OLuXd7u2RMlj5SN753V0/biz
	0lb/XfzKqdN4vteoMBd8zth2PH/RbDslluKMREMt5qLiRAAqnMXkAwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On 10/01/2014 05:14 PM, Andrzej Hajda wrote:
> The patch disables vblanks during dpms off only if pagefilp has
> not been finished. It also replaces drm_vblank_off with drm_crtc_vblank_put.
> It fixes issue with page_flip ioctl not being able to acquire vblank counter.

This problem isn't related with pageflip, it just causes from
7ffd7a68511c710b84db3548a1997fd2625f580a commit (drm: Always reject
drm_vblank_get() after drm_vblank_off()).

We need to use drm_vblank_on() as a counterpart to drm_vblank_off()
after the commit .

How about below patch?

>From 6de01473746af225c688ee430123001d57d9af2a Mon Sep 17 00:00:00 2001
From: Joonyoung Shim <jy0922.shim@samsung.com>
Date: Thu, 2 Oct 2014 17:48:27 +0900
Subject: [PATCH] drm/exynos: use drm_vblank_on()

We need to use drm_vblank_on() as a counterpart to drm_vblank_off()
after the commit 7ffd7a68511c ("drm: Always reject drm_vblank_get()
after drm_vblank_off()"). If not, drm_vblank_get() will be failed
always after drm_vblank_off().

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_crtc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index 8e38e9f..dfa209a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -71,7 +71,6 @@ static void exynos_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
 				!atomic_read(&exynos_crtc->pending_flip),
 				HZ/20))
 			atomic_set(&exynos_crtc->pending_flip, 0);
-		drm_vblank_off(crtc->dev, exynos_crtc->pipe);
 	}
 
 	if (manager->ops->dpms)
@@ -90,6 +89,7 @@ static void exynos_drm_crtc_commit(struct drm_crtc *crtc)
 	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
 	struct exynos_drm_manager *manager = exynos_crtc->manager;
 
+	drm_vblank_on(crtc->dev, exynos_crtc->pipe);
 	exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
 
 	exynos_plane_commit(crtc->primary);
@@ -177,10 +177,12 @@ static int exynos_drm_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
 
 static void exynos_drm_crtc_disable(struct drm_crtc *crtc)
 {
+	struct exynos_drm_crtc *exynos_crtc = to_exynos_crtc(crtc);
 	struct drm_plane *plane;
 	int ret;
 
 	exynos_drm_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
+	drm_vblank_off(crtc->dev, exynos_crtc->pipe);
 
 	drm_for_each_legacy_plane(plane, &crtc->dev->mode_config.plane_list) {
 		if (plane->crtc != crtc)
-- 
1.9.1

Thanks.

> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> Hi Inki,
> 
> This is fix (or just workaround) of the problem you have reported.
> Please carefully verify it, as I am not familiar with pageflip code.
> 
> Regards
> Andrzej
> ---
>  drivers/gpu/drm/exynos/exynos_drm_crtc.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> index 8e38e9f..57fa94d 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
> @@ -69,9 +69,10 @@ static void exynos_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
>  		/* wait for the completion of page flip. */
>  		if (!wait_event_timeout(exynos_crtc->pending_flip_queue,
>  				!atomic_read(&exynos_crtc->pending_flip),
> -				HZ/20))
> +				HZ/20)) {
>  			atomic_set(&exynos_crtc->pending_flip, 0);
> -		drm_vblank_off(crtc->dev, exynos_crtc->pipe);
> +			drm_crtc_vblank_put(crtc);
> +		}
>  	}
>  
>  	if (manager->ops->dpms)
> 

