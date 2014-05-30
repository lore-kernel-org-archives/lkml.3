Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaE3BgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:36:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10739 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbaE3BgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:36:06 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-13-5387e0843640
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, irlied@linux.ie, kernel@stlinux.com,
        "'Seung-Woo Kim'" <sw0312.kim@samsung.com>,
        "'Inki Dae'" <inki.dae@samsung.com>, dri-devel@lists.freedesktop.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1401381377-29973-1-git-send-email-lee.jones@linaro.org>
 <53876359.8070304@gmail.com>
In-reply-to: <53876359.8070304@gmail.com>
Subject: Re: [PATCH] drm/exynos: hdmi: remove the i2c drivers and use devtree -
 continued
Date: Fri, 30 May 2014 10:36:04 +0900
Message-id: <000701cf7ba7$85530880$8ff91980$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac97XPcbgnTW0HZpQ7uISXK6ZVr3jgASUgLA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+ZsW7Lg/Zgg1eflS2ufH3PZjHp/gQW
	i+53U5gsLi+8xGrx4cYxVov7X48yWmx6fI3V4vKuOWwWM87vY7KYMfklm8WqXX8YHbg9ds66
	y+5x59oeNo/t3x6wetzvPs7ksXlJvUffllWMHruf/WL0+LxJLoAjissmJTUnsyy1SN8ugSvj
	9Lt5LAUbeSqO7ZrA2sDYz9XFyMkhIWAisebuIyYIW0ziwr31bF2MXBxCAssYJW5POcUCU3Tv
	2UomiMQiRonOtW3MEM5vRom/Z3+AtbMJqEl8+XKYvYuRg0NEwFdiRrMWSA2zwDImiZfPfjCC
	1AgJJEss2DyXFcTmFNCUuLFmAVi9sEC0xN5Z8SBhFgFViblvZ4At5hWwlbh2ZS2ULSjxY/I9
	MJtZQEti87YmVghbXmLzmrfMIGMkBNQlHv3VBQmLCBhJXPi+mgmiRERi34t3jCDnSAgs5JCY
	//UlK8QuAYlvkw+xQPTKSmw6wAzxr6TEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJ
	BcVJ6UWGesWJucWleel6yfm5mxghCaB3B+PtA9aHGJOB1k9klhJNzgcmkLySeENjMyMLUxNT
	YyNzSzPShJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYFTQuH19z44NxkEHNkfX
	i3eWud7V68uRDxPf4qdyc+qJ9FneB3YJauefrXk3K32qcI+k97LN+48c2zitLqvy4sK2xCml
	Dxo533DIBjSfmybybPPcXyfuesy8cK2i4Tz/ddto2SmH633mpv3bpDPJLtigz4ZVxJ+Z/Wzv
	p5X2vxtCHjFdrOU4GKjEUpyRaKjFXFScCAC45pA8FgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jAd2WB+3BBsu+yVlc+fqezWLS/Qks
	Ft3vpjBZXF54idXiw41jrBb3vx5ltNj0+BqrxeVdc9gsZpzfx2QxY/JLNotVu/4wOnB77Jx1
	l93jzrU9bB7bvz1g9bjffZzJY/OSeo++LasYPXY/+8Xo8XmTXABHVAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjNPv5rEUbOSpOLZrAmsDYz9XFyMnh4SAicS9ZyuZIGwx
	iQv31rN1MXJxCAksYpToXNvGDOH8ZpT4e/YHWBWbgJrEly+H2bsYOThEBHwlZjRrgdQwCyxj
	knj57AcjSI2QQLLEgs1zWUFsTgFNiRtrFoDVCwtES+ydFQ8SZhFQlZj7dgYLiM0rYCtx7cpa
	KFtQ4sfke2A2s4CWxOZtTawQtrzE5jVvmUHGSAioSzz6qwsSFhEwkrjwfTUTRImIxL4X7xgn
	MArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4PTyTHoH46oG
	i0OMAhyMSjy8E9Lbg4VYE8uKK3MPMUpwMCuJ8DoeBgrxpiRWVqUW5ccXleakFh9iTAZ6dCKz
	lGhyPjD15ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY5PV
	UoW/d780B4rVX0p9W//M4lXr0fVqtjyCv8JZ5VL9/qkZBRqcY9L87ly/wMir0oFpMq/mtIb6
	S34vBXeE573e7nQh5zRrwTlLi5/lfsH6185J3pq46+YMprz3x94pPeZJ5z26UsfzctENyx0u
	ogddOk6tX//lY0r33sT+PVW+sdo3nk/3UWIpzkg01GIuKk4EALfjpUlzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 30, 2014 1:42 AM, Tomasz Figa wrote:
> On 29.05.2014 18:36, Lee Jones wrote:
> > There appears to have been a merge error on commit:
> >
> >   2b76813: drm/exynos: hdmi: remove the i2c drivers and use
> >
> > The original submission can be found at:
> >
> >   https://patchwork.kernel.org/patch/3559541/
> >
> > It looks like the commit was only half applied.  This patch aims
> > to finish what was started by Daniel.

(+cc Inki Dae)

Hi Lee Jones,

A similar patch was already applied to drm-exynos git. [1]
However, 'drivers/gpu/drm/exynos/exynos_hdmi.h' was not
removed yet. Thus, additional patch to remove this
'exynos_hdmi.h' should be submitted. Thank you.


[1]
http://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-exynos.git/commit/?h=exynos-drm-next&id=73c0a75ca9919c12525fd02eb49f9c3a34e0
d2d9

Best regards,
Jingoo Han

> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/gpu/drm/exynos/exynos_ddc.c     | 63 --------------------------------
> >  drivers/gpu/drm/exynos/exynos_hdmi.h    | 23 ------------
> >  drivers/gpu/drm/exynos/exynos_hdmiphy.c | 65 ---------------------------------
> >  3 files changed, 151 deletions(-)
> >  delete mode 100644 drivers/gpu/drm/exynos/exynos_ddc.c
> >  delete mode 100644 drivers/gpu/drm/exynos/exynos_hdmi.h
> >  delete mode 100644 drivers/gpu/drm/exynos/exynos_hdmiphy.c
> >
> 
> Obviously there is nothing to review, but still:
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 
> Thanks for the patch.
> 
> Best regards,
> Tomasz

