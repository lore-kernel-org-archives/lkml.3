Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3CLCI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:08:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17574 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3CLCI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:08:27 -0400
X-AuditID: cbfee68d-b7f786d000005188-2d-513e8e183d15
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <513E8E1A.9020400@samsung.com>
Date: Tue, 12 Mar 2013 11:08:26 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Inki Dae <inki.dae@samsung.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kyungmin Park <kyungmin.park@samsung.com>, sw0312.kim@samsung.com
Subject: Re: [PATCH] drivers: gpu: drm: exynos: Replaced kzalloc & memcpy with
 kmemdup
References: <1363029923-22122-1-git-send-email-gheorghiuandru@gmail.com>
In-reply-to: <1363029923-22122-1-git-send-email-gheorghiuandru@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zLV2JPrtAg4MTBC2ufH3PZrFi1xYW
	i0n3J7BYnG16w25xedccNosZk1+yObB57Jx1l93jfvdxJo++LasYPT5vkgtgieKySUnNySxL
	LdK3S+DKuDdrL2PBBt6KzZ+uszcwPubqYuTkkBAwkbj5ZCUzhC0mceHeerYuRi4OIYFljBL/
	206zwRRNnHodKjGdUWL6+T1gCV4BQYkfk++xgNjMAuoSk+YtYoawRSQeLFzJBGFrSyxb+Bos
	LiTwglHiww/5LkYOoF4tiYttwSBhFgFVieY3EK1sAuYSnR8vsUGUK0hcmXiMHaRcVCBMYufm
	dJCwiICRxLeFR5hBzmEWWMkoMWfpLlaQhLBAhMSc+b+ZIHo9JB5ePwI2k1PAU6KlqQ+sQULg
	ErvEvtenWSEWC0h8m3yIBWSBhICsxKYD0ICQlDi44gbLBEaJWUi+nIXky1lIvpyF5MsFjCyr
	GEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MUIitXcH4+0D1ocYk4HWT2SWEk3OB0Z6Xkm8obGZ
	kYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYHQ7d47S6u7Q4
	X5r9vvTm4s/tyX5/Gc7m578WY6s6HieVy3f28pLj3uc/xHQqJvSn8EW5TPP4vEemNthNXvum
	Ou+JqaFKX94F6jy5+trgVUtHt+9KlwnLYvb4d9/IeTU3erbXl91n4wpfz+RunNwxMWL96nId
	yezYyTesqt7P2PD7N1NA83dDJZbijERDLeai4kQAqAeHAuoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQV2JPrtAg8ZPXBZXvr5ns1ixawuL
	xaT7E1gszja9Ybe4vGsOm8WMyS/ZHNg8ds66y+5xv/s4k0ffllWMHp83yQWwRDUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZlyctJOlYAJvReexU8wNjIe5uhg5OSQETCQm
	Tr3OBmGLSVy4tx7I5uIQEpjOKDH9/B6wBK+AoMSPyfdYuhg5OJgF5CWOXMoGCTMLqEtMmreI
	GcQWEnjBKPHhhzxICa+AlsTFtmCQMIuAqkTzG4gSNgFzic6Pl9ggyhUkrkw8xg5SLioQJrFz
	czpIWETASOLbwiPMIBcwC6xklJizdBcrSEJYIEJizvzfTBC9HhIPrx8Bm8kp4CnR0tTHPIFR
	cBaSQ2chHDoLyaELGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH9DOpHYwrGywOMQpw
	MCrx8Cp+sw0UYk0sK67MPcQowcGsJMJbmWIXKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5
	wHSTVxJvaGxiZmRpZGZsYm5sTJqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MB+MaWbe/
	EahomP5zhlWr6NRgr4TD4sU9zeurmy0/2K/bNPdCiu6XVxWhlS4sZ5W4GCKk3Fvypzd8DFDs
	tLpwLEJYT25m67Fwi2VZqunzOfcW6t959zTSdF2184+CV6sK+I/PfSnSukG4dteBB48OBjx/
	VxDxR93x3l12zR1r3du0+ev2zTdVYinOSDTUYi4qTgQAlrS6/S0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good point.

Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>

On 2013년 03월 12일 04:25, Alexandru Gheorghiu wrote:
> Replaced calls to kzalloc followed by memcpy with call to kmemdup.
> Patch found using coccinelle.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_vidi.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_vidi.c b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> index 13ccbd4..9504b0c 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> @@ -117,13 +117,12 @@ static struct edid *vidi_get_edid(struct device *dev,
>  	}
>  
>  	edid_len = (1 + ctx->raw_edid->extensions) * EDID_LENGTH;
> -	edid = kzalloc(edid_len, GFP_KERNEL);
> +	edid = kmemdup(ctx->raw_edid, edid_len, GFP_KERNEL);
>  	if (!edid) {
>  		DRM_DEBUG_KMS("failed to allocate edid\n");
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	memcpy(edid, ctx->raw_edid, edid_len);
>  	return edid;
>  }
>  
> @@ -563,12 +562,11 @@ int vidi_connection_ioctl(struct drm_device *drm_dev, void *data,
>  			return -EINVAL;
>  		}
>  		edid_len = (1 + raw_edid->extensions) * EDID_LENGTH;
> -		ctx->raw_edid = kzalloc(edid_len, GFP_KERNEL);
> +		ctx->raw_edid = kmemdup(raw_edid, edid_len, GFP_KERNEL);
>  		if (!ctx->raw_edid) {
>  			DRM_DEBUG_KMS("failed to allocate raw_edid.\n");
>  			return -ENOMEM;
>  		}
> -		memcpy(ctx->raw_edid, raw_edid, edid_len);
>  	} else {
>  		/*
>  		 * with connection = 0, free raw_edid
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

