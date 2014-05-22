Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaEVLxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:53:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58706 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaEVLxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:53:04 -0400
X-AuditID: cbfee68f-b7fef6d000003970-59-537de51d846c
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <537DE51D.6080309@samsung.com>
Date: Thu, 22 May 2014 20:53:01 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 0/8] drm/exynos/ipp: image post processing improvements
References: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsWyRsSkUFf2aW2wwYPv6ha31p1jtbjy9T2b
	xYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHDo/73ceZPPq2rGL0+LxJLoA5issm
	JTUnsyy1SN8ugSuj7/dzloJlnBWXT19gbWA8wd7FyMkhIWAiMffvY0YIW0ziwr31bF2MXBxC
	AksZJdYdu80CU7Rn20Y2EFtIYDqjxO8nQiA2r4CgxI/J98BqmAXUJSbNW8QMYYtIvGo4CBXX
	lli28DUzxNBXjBIXv3xihmjWkji6eBIriM0ioCrRuOEP2BVsQPbEFffBlokKhEm8eLULrF4E
	aMHsk3egFpxhkjjwUqCLkYNDWMBbYv6DdIjbnCUe7zoK9hingIvEiWPLWUH2SgicYpc48PQi
	I8QuAYlvkw+xgPRKCMhKbDrADPGjpMTBFTdYJjCKz0Ly2iwkr81C8tosJK8tYGRZxSiaWpBc
	UJyUXmSsV5yYW1yal66XnJ+7iREYm6f/PevfwXj3gPUhxmSg9ROZpUST84GxnVcSb2hsZmRh
	amJqbGRuaUaasJI47/2HSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGINvFMlqb1926OHv
	yg3d6w6/ldwf0qu0jsPZj+t+7Y3pcR+OZ2/i/hF24OmNb3/9HO1s7VrcLAIKzBznN01M4LAU
	uTHlevrn9p5aq3Jtzz/NUZG/HbziqoKZt+ZOTz/BtX7S3pbu2OfxalsW3Z+wulaaY6HH3ydb
	H8dNUuY8/eLD+xU27xykrJVYijMSDbWYi4oTAWs3h97jAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jQV3Zp7XBBk8/y1vcWneO1eLK1/ds
	Fi/uXWSxONv0ht3i8q45bBYzzu9jslh75C67xYzJL9kcODzudx9n8ujbsorR4/MmuQDmqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGedubGYrmMJZMef9avYGxm3sXYyc
	HBICJhJ7tm1kg7DFJC7cWw9mCwlMZ5T4/UQIxOYVEJT4MfkeSxcjBwezgLzEkUvZIGFmAXWJ
	SfMWMXcxcgGVv2KUuPjlEzNEvZbE0cWTWEFsFgFVicYNfxhBbDYge+KK+2DzRQXCJF682gVW
	LwI0aPbJO8wQQ88wSRx4KQCyS1jAW2L+g3SIc5wlHu86CnYyp4CLxIljy1knMArMQnLdLITr
	ZiG5bgEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Ch+Jr2DcVWDxSFGAQ5GJR7eG+dr
	goVYE8uKK3MPMUpwMCuJ8O47UxssxJuSWFmVWpQfX1Sak1p8iDEZ6LeJzFKiyfnABJNXEm9o
	bGJmZGlkbmhhZGxOmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzZca8iN4stPvje9sGi
	Tc9tbji18H2bs/zbG883t+bldq8O4I1/IN+2o335jqdMa2ZlL3S8+8/4ZUh/5vdV5xSZjI84
	TOWR0473Yczwz9/ZGc7IuHOP0CxPGy3uHxPUFY11Nxcb5sroX7bhLiiVFGO8ruCwU131sfI9
	MQmVFnchptc8trcW5yuxFGckGmoxFxUnAgCdOBwRJgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 05월 19일 19:54, Andrzej Hajda wrote:
> This set of independent patches contains various improvement and fixes
> for exynos_drm ipp framework and drivers.
> The patchset is based on drm-exynos/exynos-drm-next branch.

Thanks for contributions and merged.

Thanks,
Inki Dae

> 
> Regards
> Andrzej
> 
> 
> Andrzej Hajda (8):
>   drm/exynos/ipp: fix get_property IOCTL
>   drm/exynos/ipp: correct ipp_id field initialization
>   drm/exynos/ipp: simplify property list allocation
>   drm/exynos/fimc: simplify pre-scaler ratio calculation
>   drm/exynos/fimc: simplify irq masking function
>   drm/exynos/fimc: replace hw access macros with functions
>   drm/exynos/fimc: replace mutex by spinlock
>   drm/exynos/fimc: simplify and rename fimc_dst_get_buf_seq
> 
>  drivers/gpu/drm/exynos/exynos_drm_fimc.c    | 427 ++++++++++++----------------
>  drivers/gpu/drm/exynos/exynos_drm_gsc.c     |  10 +-
>  drivers/gpu/drm/exynos/exynos_drm_ipp.c     |  16 +-
>  drivers/gpu/drm/exynos/exynos_drm_ipp.h     |   3 +-
>  drivers/gpu/drm/exynos/exynos_drm_rotator.c |   8 +-
>  5 files changed, 196 insertions(+), 268 deletions(-)
> 

