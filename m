Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaEGFOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 01:14:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12682 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaEGFOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 01:14:40 -0400
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
X-AuditID: cbfee68d-b7f4e6d000004845-44-5369c13e2b4a
Content-transfer-encoding: 8BIT
Message-id: <5369C13C.3080506@samsung.com>
Date: Wed, 07 May 2014 14:14:36 +0900
From: Seung-Woo Kim <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanpaul@chromium.org, marcheu@chromium.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCH 2/4] drm/exynos/mixer: use MXR_GRP_SXY_SY
References: <1399217181-26442-1-git-send-email-djkurtz@chromium.org>
 <1399217181-26442-3-git-send-email-djkurtz@chromium.org>
In-reply-to: <1399217181-26442-3-git-send-email-djkurtz@chromium.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWyRsSkQNfuYGawwflteha9504yWTTOmM9q
	ceXrezaLSfcnsFi8uHeRxaJ3wVU2i7NNb9gtNj2+xmpxedccNosZ5/cxWcw79JvR4u6Gs4wW
	Mya/ZHPg9ZjdcJHFY/u3B6we97uPM3lsXlLv0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBnL
	Nz9mK+jmqbgxcSpTA+Mrzi5GTg4JAROJ543zGSFsMYkL99azgdhCAksZJfYdsoOp2b3yAnMX
	IxdQfDqjxOTzj5hAErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoCEx9fVpRoj614wSM5ZOYYOo
	15I4s+cM2DIWAVWJBzM6WEFsNgEdif1LfrNCLFaQuDLxGDvITFGBMImdm9NBTBEBdYlfN5xA
	RjILLGOWuLz1FNhIYQFbie62F+wQrfUSsxvngMU5BVwlNpz+yQ7SICEwlUNiy94ZTBB7BSS+
	TT4EdrOEgKzEpgPMED9KShxccYNlAqP4LCSfzUL4bBaSzxYwMq9iFE0tSC4oTkovMtQrTswt
	Ls1L10vOz93ECIzm0/+e9e5gvH3A+hBjMtDGicxSosn5wGSQVxJvaGxmZGFqYmpsZG5pRpqw
	kjhv0sOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MG94WTbx4JPTsk6o/lUtPsHEr27qV
	22/aWHuGPTtg+cYb0dxePbJh7vsV+5313qQKNK7SUdadtnDnlC9Rx5QfaPfqpXfJ2C3xNDLo
	KjsgXTDvS+OWzqWzuOYq8Pt2fzHfLLON8aDEFLnZkasstKL0arRX1Wm9nKy0/cCpj4x3jj+5
	wH8qbMIzJZbijERDLeai4kQAHf/QX/wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQV27g5nBBpv2qVr0njvJZNE4Yz6r
	xZWv79ksJt2fwGLx4t5FFoveBVfZLM42vWG32PT4GqvF5V1z2CxmnN/HZDHv0G9Gi7sbzjJa
	zJj8ks2B12N2w0UWj+3fHrB63O8+zuSxeUm9R9+WVYwenzfJBbBFNTDaZKQmpqQWKaTmJeen
	ZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdqqRQlphTChQKSCwuVtK3wzQh
	NMRN1wKmMULXNyQIrsfIAA0krGHMWL75MVtBN0/FjYlTmRoYX3F2MXJySAiYSOxeeYEZwhaT
	uHBvPVsXIxeHkMB0RonJ5x8xgSR4BQQlfky+x9LFyMHBLCAvceRSNkiYWUBDYurr04wQ9a8Z
	JWYsncIGUa8lcWbPGUYQm0VAVeLBjA5WEJtNQEdi/5LfYLaQgILElYnH2EFmigqESezcnA5i
	igioS/y64QQykllgGbPE5a2nwEYKC9hKdLe9YIdorZeY3TgHLM4p4Cqx4fRP9gmMgrOQXDoL
	4dJZSC5dwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4WTyT3sG4qsHiEKMAB6MSD6/F
	24xgIdbEsuLK3EOMEhzMSiK8Nvsyg4V4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5jI8kri
	DY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBMU3VZdvC2mlWbax7
	zrs3xGY8jGFvTnR2UX3c2ZtxdEvkbS4Gvc2rupLW/itm/7pju8WmeFU2sahlte39n/JdFr5l
	U/ZgmZyh7qCgwlG14MA7OXNp54i5m2qXB/sYNjWkvZG9pLL6nfvbJ5UX1213dXww603i8QcS
	zj/Tj/1cWp8vqPPtL+cTJZbijERDLeai4kQA7JNUpVoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 2014³â 05¿ù 05ÀÏ 00:26, Daniel Kurtz wrote:
> Mixer hardware supports offsetting dma from start of source buffer using
> the MXR_GRP_SXY register.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/gpu/drm/exynos/exynos_mixer.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
> index 475eb49..40cf39b 100644
> --- a/drivers/gpu/drm/exynos/exynos_mixer.c
> +++ b/drivers/gpu/drm/exynos/exynos_mixer.c
> @@ -529,13 +529,11 @@ static void mixer_graph_buffer(struct mixer_context *ctx, int win)
>  
>  	dst_x_offset = win_data->crtc_x;
>  	dst_y_offset = win_data->crtc_y;
> +	src_x_offset = win_data->fb_x;
> +	src_y_offset = win_data->fb_y;
>  
>  	/* converting dma address base and source offset */
> -	dma_addr = win_data->dma_addr
> -		+ (win_data->fb_x * win_data->bpp >> 3)
> -		+ (win_data->fb_y * win_data->fb_width * win_data->bpp >> 3);
> -	src_x_offset = 0;
> -	src_y_offset = 0;
> +	dma_addr = win_data->dma_addr;

Basically, you are right and source offset register can be used. But
because of limitation of resolution for mixer up to 1920x1080, I
considered modified soruce dma address to set one frame buffer, which is
bigger than 1920x1080, on to both fimd and hdmi.

Regards,
- Seung-Woo Kim

>  
>  	if (win_data->scan_flags & DRM_MODE_FLAG_INTERLACE)
>  		ctx->interlace = true;
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

