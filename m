Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaKMIuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:50:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62003 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaKMIuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:50:06 -0500
X-AuditID: cbfee68d-f79296d000004278-fe-546470bc3938
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <546470BC.4020104@samsung.com>
Date: Thu, 13 Nov 2014 17:50:04 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] drm/exynos/dsi: remove global display variable
References: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWyRsSkSHdPQUqIwczNEha31p1jtbjy9T2b
	xYt7F1ksehdcZbM42/SG3eLyrjlsFjPO72OyWHvkLrvFjMkv2Rw4Pe53H2fy6NuyitHj8ya5
	AOYoLpuU1JzMstQifbsEroxzP+4zFVzgrNh/eAZjA+NT9i5GDg4JAROJ9nc2XYycQKaYxIV7
	69m6GLk4hASWMkrcfdfODJEwkTgz9wcrRGI6o8TXU08ZQRK8AoISPybfYwGxmQXUJSbNW8QM
	YYtIfJs/lRXC1pZYtvA1M0TzK0aJV1P7mCCatST2zV0E1swioCrR/ruTDcRmA7InrrgPZosK
	hEm8eLULbKgI0ILZJ++ADWIWmMoscWFRD1izsIC7xKPVa8BsIQFnicmnt4It4BRwkZi34RXY
	PxICl9glLhx+zAyxTUDi2+RDLBD/y0psOgD1pqTEwRU3WCYwis9C8twsJM/NQvLcLCTPLWBk
	WcUomlqQXFCclF5kqFecmFtcmpeul5yfu4kRGKmn/z3r3cF4+4D1IUYBDkYlHt4XLCkhQqyJ
	ZcWVuYcYTYEumsgsJZqcD0wHeSXxhsZmRhamJqbGRuaWZkrivIpSP4OFBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MEq0nzCd3XHgdH7t7rIJtdzaLhmZE81rLtf6L937r05dR0nBtmvu1pjC
	6NSHYrIpex04JinaZVVHToprnC0Xs1zvvoyF6p7gJfdqnM8c2FQYm8t83/jd1cAH2j9zs84d
	nVpqUxIgv+hdYlQ4u9tfpx0Ryzv/5uSV77dcVsu2lPmWwDJFUVMPJZbijERDLeai4kQA1bOV
	W88CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t9jQd09BSkhBnOe8FvcWneO1eLK1/ds
	Fi/uXWSx6F1wlc3ibNMbdovLu+awWcw4v4/JYu2Ru+wWMya/ZHPg9LjffZzJo2/LKkaPz5vk
	ApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmXLtzm6VgD2fFnV+LWBsY
	L7J3MXJySAiYSJyZ+4MVwhaTuHBvPVsXIxeHkMB0Romvp54ygiR4BQQlfky+x9LFyMHBLCAv
	ceRSNkiYWUBdYtK8RcwQ9a8YJV5N7WOCqNeS2Dd3EQuIzSKgKtH+u5MNxGYDsieuuA9miwqE
	Sbx4tYsZxBYBGjT75B2wQcwCU5klLizqAWsWFnCXeLR6DZgtJOAsMfn0VrAFnAIuEvM2vGKb
	wCgwC8l9sxDum4XkvgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgqP6mfQOxlUNFocY
	BTgYlXh4X7CkhAixJpYVV+YeYpTgYFYS4W3SAQrxpiRWVqUW5ccXleakFh9iNAX6biKzlGhy
	PjDh5JXEGxqbmBlZGpkbWhgZmyuJ8x5stQ4UEkhPLEnNTk0tSC2C6WPi4JRqYLQ7Zbb8y/E7
	SaJPKsy+zSvfp5DJ7hAyzfeYyam5zBuiin6meBX/r/SbM7vrUYCzl9gm7+X82+ZMz268rCTj
	dF/x9GL1XfdeL65buXXKo6UH7j9g2vSZ+Vonc7RG5rLZTB337k6Y9MHvxEFDO67Up55cxnM3
	uMi9WaDHsnJz1HkzHl4L/bMVJmeUWIozEg21mIuKEwHLCm5AAAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 10월 07일 21:01, Andrzej Hajda wrote:
> Hi Inki,
> 
> Many Exynos DRM drivers uses global variables to represent associated devices
> in Exynos DRM internal framework. It is quite confusing, it adds data duplication
> and finally it does not allow to handle more than one device in system.
> It seems better to embed such structures in private context of the device.
> 
> The patchset is based on exynos_drm_next plus my patch [1]:
> 'drm/exynos: remove explicit encoder/connector de-initialization'.
> 
> If the patchset is OK for you I can prepare similar patches for other Exynos DRM components.

Sorry for late. Applied. Can you prepare similar patches for other? If
so, I'd happy.

Thanks,
Inki Dae

> 
> [1]: https://lkml.org/lkml/2014/9/22/148
> 
> Regards
> Andrzej
> 
> 
> Andrzej Hajda (4):
>   drm/exynos/dsi: remove global variable exynos_dsi_display
>   drm/exynos/dsi: simplify device pointer evaluation
>   drm/exynos/dsi: remove redundant encoder field
>   drm/exynos/dsi: stop using display->ctx pointer
> 
>  drivers/gpu/drm/exynos/exynos_drm_dsi.c | 96 ++++++++++++++++-----------------
>  1 file changed, 47 insertions(+), 49 deletions(-)
> 

