Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaIQLo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:44:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9092 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbaIQLoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:44:55 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-f797f6d000001173-cb-5419742c2eb3
Content-transfer-encoding: 8BIT
Message-id: <5419742B.4090907@samsung.com>
Date: Wed, 17 Sep 2014 20:44:43 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 0/9] drm/exynos: initialization/deinitialization fixes
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsWyRsSkRFenRDLEoHcdh8WtdedYLa58fc9m
	8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2Bw+N+93Emj74tqxg9Pm+SC2CO4rJJ
	Sc3JLEst0rdL4MpY0PmUueACb8WH/81MDYwN3F2MnBwSAiYSjx/dZoKwxSQu3FvP1sXIxSEk
	sJRRYsXH/SwwRdf+dbFAJKYzSpy6ch2sg1dAUOLH5HtACQ4OZgF5iSOXskHCzALqEpPmLWKG
	qH/FKHHt4lF2iHotiR8Hf4PZLAKqEjNutYAtYAOyJ664zwZiiwqESbx4tYsZxBYBGjT75B2w
	QcwCZ5gkTh5YwwiSEBbwkpiwcQcriC0k4CSx4O03dpAjOAWcJd7+CwCplxA4xy7xY8NRVohl
	AhLfJh8CO1RCQFZi0wFmiMckJQ6uuMEygVFsFpJ3ZiG8MwvJOwsYmVcxiqYWJBcUJ6UXGesV
	J+YWl+al6yXn525iBMba6X/P+ncw3j1gfYhRgINRiYd3w2WJECHWxLLiytxDjKZAR0xklhJN
	zgdGdF5JvKGxmZGFqYmpsZG5pZmSOO9CqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgt
	bul7fe7/MOdfuNRSz+9fsj0LLj120ebdPedp5ZT9l5h+vPzzddq1nB8nH7Y/U/m83+GU5MtU
	/mVG+w78inrRdmhXtM+m+kvr5RRXGnnnSAev6Y+f+65J758Gq/1Mt4SUle9Xez1zvHDBeY1Q
	8Zx50YlTQrfdu++tpy7GXvdcyXjW5hPKVbk2SizFGYmGWsxFxYkAoAsw+rACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jQV2dEskQg4XfGC1urTvHanHl63s2
	ixf3LrJYnG16w25xedccNosZ5/cxWaw9cpfdYsbkl2wOHB73u48zefRtWcXo8XmTXABzVAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QCUoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjAWdT5kLLvBWfPjfzNTA2MDdxcjJ
	ISFgInHtXxcLhC0mceHeerYuRi4OIYHpjBKnrlxnAknwCghK/Jh8D6iIg4NZQF7iyKVskDCz
	gLrEpHmLmCHqXzFKXLt4lB2iXkvix8HfYDaLgKrEjFstYAvYgOyJK+6zgdiiAmESL17tYgax
	RYAGzT55B2wQs8AZJomTB9YwgiSEBbwkJmzcwQpiCwk4SSx4+40d5AhOAWeJt/8CJjAKzEJy
	3iyE82YhOW8BI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBIfia1g3Flg8UhRgEORiUe
	3g2XJUKEWBPLiitzDzFKcDArifD2BUuGCPGmJFZWpRblxxeV5qQWH2I0BXpuIrOUaHI+MMnk
	lcQbGpuYGVkamRtaGBmbK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpgXOz/5ZLUp7V/GvbM
	qnVXiT9QwnE31u2i2ItbmyqbS177n46SWHn24Id5m5Y1l1+2a96fdinzh9y1cwV/487YvTi4
	q+cIQ9kEoTc5ES0HS5s3H4p6eDMvUdV/10RWsw3Hoz5IBNy0/fgnJeaAfezFb8ZyB76ovpZf
	6G3312WtvI3ScuEF8fNv7FRiKc5INNRiLipOBAAvJKId+gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 09월 09일 22:16, Andrzej Hajda wrote:
> This set of patches contains fixes of initialization and deinitialization
> code of exynos_drm core and components.
> It is based on exynos-drm-next branch.
> 
> Patchset has been tested on trats and universal_c210 platforms.

Applied all patches except patch #5. As of now, it seems good to merge
also patch #5 if you couldn't post next version of that patch until the
end of this week. In this case, I will have a pull request including
that patch so that we can fix it up correctly later. Give me your
opinion if there is other plan.

Thanks,
Inki Dae

> 
> Regards
> Andrzej
> 
> 
> Andrzej Hajda (9):
>   drm/exynos/ipp: traverse ipp drivers list safely
>   drm/exynos: fix drm driver de-initialization order
>   drm/exynos/fbdev: fix fbdev gem object cleanup
>   drm/exynos/fb: free exynos framebuffer on error
>   drm/exynos/crtc: fix framebuffer reference sequence
>   drm/exynos/dsi: unregister connector on removal
>   drm/exynos/dpi: unregister connector and panel on removal
>   drm/exynos/dp: unregister connector on removal
>   drm/exynos/hdmi: unregister connector on removal
> 
>  drivers/gpu/drm/exynos/exynos_dp_core.c   | 4 +++-
>  drivers/gpu/drm/exynos/exynos_drm_crtc.c  | 6 ++++++
>  drivers/gpu/drm/exynos/exynos_drm_dpi.c   | 6 +++++-
>  drivers/gpu/drm/exynos/exynos_drm_drv.c   | 8 ++++----
>  drivers/gpu/drm/exynos/exynos_drm_dsi.c   | 9 ++++++---
>  drivers/gpu/drm/exynos/exynos_drm_fb.c    | 1 +
>  drivers/gpu/drm/exynos/exynos_drm_fbdev.c | 3 ---
>  drivers/gpu/drm/exynos/exynos_drm_ipp.c   | 4 ++--
>  drivers/gpu/drm/exynos/exynos_hdmi.c      | 4 +++-
>  9 files changed, 30 insertions(+), 15 deletions(-)
> 

