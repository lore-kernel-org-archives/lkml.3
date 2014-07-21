Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaGUJXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:23:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34211 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaGUJX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:23:29 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-d7-53ccdc0d4152
Content-transfer-encoding: 8BIT
Message-id: <53CCDBF5.9080605@samsung.com>
Date: Mon, 21 Jul 2014 11:23:01 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
To: Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 00/12] drm/exynos/ipp: image post processing improvements,
 part three
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
 <53BD5615.8060900@samsung.com>
In-reply-to: <53BD5615.8060900@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xq7q8d84EG9yda2Rx5et7NotJ9yew
	WLy4d5HF4mzTG3aLy7vmsFnMOL+PyWLtkbvsFjMmv2Rz4PC4332cyaNvyypGj8+b5AKYo7hs
	UlJzMstSi/TtErgyNkwQKPjCU3FwyizWBsYDXF2MnBwSAiYS624dY4WwxSQu3FvP1sXIxSEk
	sJRRYvLW62AJXgFBiR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxEzRP0nRonjO5cxQ9RrSRxY
	8BXMZhFQlfiz9S/YHDYBTYm/m2+ygdiiAhESB/qegcVFBJQlVu1rZwcZxCxwhkni5IE1jCAJ
	YYFoiTkPXzOB2EICKRJ7jh4Ea+YU0JZYdO0U+wRGgVlI7puFcN8sJPctYGRexSiaWppcUJyU
	nmuoV5yYW1yal66XnJ+7iRES2F92MC4+ZnWIUYCDUYmHl+HhqWAh1sSy4srcQ4wSHMxKIrwn
	Ms4EC/GmJFZWpRblxxeV5qQWH2Jk4uCUamBkV94qUc9/QXV95IdP4Tcb7WWCQgW2yO2Ism61
	jo140cI1vdyv2VJxg8uO5dvEztr9Xa234NrWrd+eZgidehy74rvJFcblV05Pupw7q216ddCn
	//pWnNnPbfwkwr14NZesnbZAce72092Hjnke7G9f7nf2+wJhhS9KRw/82bzyasdf69rtTUU8
	SizFGYmGWsxFxYkAivHNBUoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Inki,

On 07/09/2014 04:47 PM, Inki Dae wrote:
> On 2014년 07월 03일 22:10, Andrzej Hajda wrote:
>> This set of independent patches contains various improvement and fixes
>> for exynos_drm ipp framework.
>> The patchset is based on exynos-drm-next branch.
>>
> Did you test ipp module using libdrm? If so, can you share the app? I
> would try to test this patch series before merging them. Mainline libdrm
> has no any ipp interfaces.

I have used ipptest program developed by you :), with minor changes.
More advanced tests are on my TODO list, but for this patchset ipptest
seems to be OK - the patches are mainly cleanup patches.

Regards
Andrzej

>
> Thanks,
> Inki Dae
>
>> Regards
>> Andrzej
>>
>>
>> Andrzej Hajda (12):
>>   drm/exynos/ipp: remove type casting
>>   drm/exynos/ipp: remove unused field from exynos_drm_ipp_private
>>   drm/exynos/ipp: remove struct exynos_drm_ipp_private
>>   drm/exynos/ipp: correct address type
>>   drm/exynos/ipp: remove temporary variable
>>   drm/exynos/ipp: remove incorrect checks of list_first_entry result
>>   drm/exynos/ipp: simplify memory check function
>>   drm/exynos/ipp: remove useless registration checks
>>   drm/exynos/ipp: simplify ipp_find_obj
>>   drm/exynos/ipp: remove redundant messages
>>   drm/exynos/ipp: simplify ipp_create_id
>>   drm/exynos/ipp: simplify ipp_find_driver
>>
>>  drivers/gpu/drm/exynos/exynos_drm_drv.h |   7 +-
>>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 259 +++++++++-----------------------
>>  drivers/gpu/drm/exynos/exynos_drm_ipp.h |   4 +-
>>  3 files changed, 73 insertions(+), 197 deletions(-)
>>
>

