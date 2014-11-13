Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbaKMOO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:14:28 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10408 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055AbaKMOO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:14:26 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-12-5464bcbf1553
Content-transfer-encoding: 8BIT
Message-id: <5464BCBE.1090001@samsung.com>
Date: Thu, 13 Nov 2014 15:14:22 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
To: Inki Dae <inki.dae@samsung.com>
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
 <546470BC.4020104@samsung.com>
In-reply-to: <546470BC.4020104@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xq7r796SEGCz4aGhx5et7NotJ9yew
	WLy4d5HFonfBVTaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mr4//4nU8Furoo53TtYGhj3cHQxcnJICJhI9O/uY4WwxSQu3FvP
	1sXIxSEksJRRoufsNjaQBK+AoMSPyfdYuhg5OJgF5CWOXMqGMNUlpkzJhSj/xCjRfG0tM0ic
	V0BL4uQaQ5BOFgFViY7bi8HGswloSvzdfBNsoqhAhMSVNXMYQWwRAWWJVfva2UHmMAtMZZa4
	sKiHBSQhLOAu8Wj1GjBbSCBFYu68mWCDOAW0Jebv3cU2gVFgFpLrZiFcNwvhugWMzKsYRVNL
	kwuKk9JzDfWKE3OLS/PS9ZLzczcxQsL7yw7GxcesDjEKcDAq8fB+4E4JEWJNLCuuzD3EKMHB
	rCTC+2YlUIg3JbGyKrUoP76oNCe1+BAjEwenVAOjzpwHr36ILFDmLz/x60F5YYTzp196MZF3
	Jmm+11sQ9nqL455aj1XNqcsSD++2f6hR6KCUPlNT7uTU54E3tneuT+i97b6jXyPh0LJzmQFc
	6Re1vTtcva+lsPvdj1EUfjTp7pa/8q8yXK849KRsWBHr97BNfEnagb7L/4KZ73E1rus9EJx+
	3/SfEktxRqKhFnNRcSIAEyk88k0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 09:50 AM, Inki Dae wrote:
> On 2014년 10월 07일 21:01, Andrzej Hajda wrote:
>> Hi Inki,
>>
>> Many Exynos DRM drivers uses global variables to represent associated devices
>> in Exynos DRM internal framework. It is quite confusing, it adds data duplication
>> and finally it does not allow to handle more than one device in system.
>> It seems better to embed such structures in private context of the device.
>>
>> The patchset is based on exynos_drm_next plus my patch [1]:
>> 'drm/exynos: remove explicit encoder/connector de-initialization'.
>>
>> If the patchset is OK for you I can prepare similar patches for other Exynos DRM components.
> Sorry for late. Applied. Can you prepare similar patches for other? If
> so, I'd happy.

Beginning of the next week is OK?

Regards
Andrzej

>
> Thanks,
> Inki Dae
>
>> [1]: https://lkml.org/lkml/2014/9/22/148
>>
>> Regards
>> Andrzej
>>
>>
>> Andrzej Hajda (4):
>>   drm/exynos/dsi: remove global variable exynos_dsi_display
>>   drm/exynos/dsi: simplify device pointer evaluation
>>   drm/exynos/dsi: remove redundant encoder field
>>   drm/exynos/dsi: stop using display->ctx pointer
>>
>>  drivers/gpu/drm/exynos/exynos_drm_dsi.c | 96 ++++++++++++++++-----------------
>>  1 file changed, 47 insertions(+), 49 deletions(-)
>>
>

