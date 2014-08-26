Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaHZF5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:57:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37602 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaHZF5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:57:53 -0400
X-AuditID: cbfee68d-f79c46d000000b84-a0-53fc21dea962
Message-id: <53FC21DF.1010504@samsung.com>
Date: Tue, 26 Aug 2014 14:57:51 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 15/15] drm/exynos/fimc: fix source buffer registers
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
 <1408693946-15456-16-git-send-email-a.hajda@samsung.com>
In-reply-to: <1408693946-15456-16-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsWyRsSkQPee4p9gg4NXbSxurTvHanHl63s2
	i0n3J7BYvLh3kcXibNMbdovLu+awWcw4v4/JYu2Ru+wWMya/ZHPg9LjffZzJo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDIedLWwFWzmr9iz8xZ7A+MZni5GTg4JAROJ+dfesELYYhIX7q1n
	62Lk4hASWMoosehNHxtM0e+bc9khEtMZJT6cPANV9YpRYs7zKYwgVbwCWhItR94zg9gsAqoS
	Daens4PYbAJ6Ene2HWcCsUUFQiTeHG9nh6gXlPgx+R4LiC0i4CEx/80esF5mgTNMEl/X64LY
	wgLuEl83bAaKcwAtq5NoXWcJYnIKuEpseicNYjIDTb9/UQuiUV5i85q3zCCXSQicYpd4c34H
	K8Q1AhLfJh9iAamXEJCV2HSAGeItSYmDK26wTGAUm4XknlkIU2chmbqAkXkVo2hqQXJBcVJ6
	kaFecWJucWleul5yfu4mRmDEnf73rHcH4+0D1ocYBTgYlXh4b8T/DhZiTSwrrsw9xGgKdMRE
	ZinR5HxgXOeVxBsamxlZmJqYGhuZW5opifMqSv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp
	1cAo3j758zv/QIkvugfdeGc6iuj9dzZz8RMveTtZJWbl5pvdFW+ZxesK/bUblj4/0X3yw722
	z6H8Qp8j9iwUCV5m8CdhTy0vt/wc5m/rL2xJOLAn4/OT7KhFcTavX91s7Wn2CNBffja2dq/b
	lvPa724+Eb9kyqlm8j2If3as8jKOOy83NC+LP12hxFKckWioxVxUnAgALqLnwrMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jQd17in+CDa5vMbW4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8aCrha1gM3/Fnp232BsY
	z/B0MXJySAiYSPy+OZcdwhaTuHBvPVsXIxeHkMB0RokPJ89AOa8YJeY8n8IIUsUroCXRcuQ9
	M4jNIqAq0XB6Olg3m4CexJ1tx5lAbFGBEIk3x9vZIeoFJX5MvscCYosIeEjMf7MHrJdZ4AyT
	xNf1uiC2sIC7xNcNm4HiHEDL6iRa11mCmJwCrhKb3kmDmMxA0+9f1IJolJfYvOYt8wRGgVlI
	5s9CqJqFpGoBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOB4fia9g3FVg8UhRgEORiUe
	3hvxv4OFWBPLiitzDzFKcDArifAyPAQK8aYkVlalFuXHF5XmpBYfYjQF+n4is5Rocj4w1eSV
	xBsam5gZWRqZG1oYGZsrifMebLUOFBJITyxJzU5NLUgtgulj4uCUamAUferw63/3LzHHr0/O
	xd/6yndk2UrzpJuCK2wLTzisLr131/33m29PZ1iEnj5RzPZ217dN2pcWCTZyiB84Y+xveMUo
	Y4pE9e9vUwznR1yRXyKq2msvNP3NbiV+3SRpVutDYkq/s7mW6H2XPXVp+ss3LKbhnObtIX9s
	vI9Y8dseZmRtCiytEbyrxFKckWioxVxUnAgA/xtKv/0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
> FIMC in default mode of operation uses only one input buffer,
> but the driver used also second buffer, as a result only the
> first frame was processed correctly. The patch fixes it.

I can't understand well, then we don't need to distinguish buf_id in
fimc_src_set_addr()?

> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimc.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
> index b20078e..e985253 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
> @@ -720,24 +720,24 @@ static int fimc_src_set_addr(struct device *dev,
>  	case IPP_BUF_ENQUEUE:
>  		config = &property->config[EXYNOS_DRM_OPS_SRC];
>  		fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_Y],
> -			EXYNOS_CIIYSA(buf_id));
> +			EXYNOS_CIIYSA0);
>  
>  		if (config->fmt == DRM_FORMAT_YVU420) {
>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
> -				EXYNOS_CIICBSA(buf_id));
> +				EXYNOS_CIICBSA0);
>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
> -				EXYNOS_CIICRSA(buf_id));
> +				EXYNOS_CIICRSA0);
>  		} else {
>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
> -				EXYNOS_CIICBSA(buf_id));
> +				EXYNOS_CIICBSA0);
>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
> -				EXYNOS_CIICRSA(buf_id));
> +				EXYNOS_CIICRSA0);
>  		}
>  		break;
>  	case IPP_BUF_DEQUEUE:
> -		fimc_write(ctx, 0x0, EXYNOS_CIIYSA(buf_id));
> -		fimc_write(ctx, 0x0, EXYNOS_CIICBSA(buf_id));
> -		fimc_write(ctx, 0x0, EXYNOS_CIICRSA(buf_id));
> +		fimc_write(ctx, 0x0, EXYNOS_CIIYSA0);
> +		fimc_write(ctx, 0x0, EXYNOS_CIICBSA0);
> +		fimc_write(ctx, 0x0, EXYNOS_CIICRSA0);
>  		break;
>  	default:
>  		/* bypass */
> 

