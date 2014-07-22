Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaGVAy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:54:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49910 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaGVAy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:54:56 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7fb56d000003439-2a-53cdb65dd045
Content-transfer-encoding: 8BIT
Message-id: <53CDB65D.4010105@samsung.com>
Date: Tue, 22 Jul 2014 09:54:53 +0900
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
Subject: Re: [PATCH 00/12] drm/exynos/ipp: image post processing improvements,
 part three
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
 <53BD5615.8060900@samsung.com> <53CCDBF5.9080605@samsung.com>
In-reply-to: <53CCDBF5.9080605@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWyRsSkUDd229lgg3ePLS1urTvHanHl63s2
	ixf3LrJYnG16w25xedccNosZ5/cxWaw9cpfdYsbkl2wOHB73u48zefRtWcXo8XmTXABzFJdN
	SmpOZllqkb5dAlfGhp23mQquCVTcWTSPuYFxP28XIyeHhICJxPcJ35ghbDGJC/fWs3UxcnEI
	CSxllJh3ewcTTNHTSytYIBKLGCWOnN4D1sErICjxY/I9oAQHB7OAvMSRS9kgYWYBdYlJ8xYx
	Q9S/AhrU85kJol5LYsP386wgNouAqsTPnndgcTYge+KK+2wgtqhAmMSLV7vA5osADZp98g7Y
	IGaBM0wSJw+sYQRJCAtES8x5+JoJYkMzo8SaXx/BJnEKaEtM2XAK7FQJgVPsEg/O3IZaJyDx
	bfIhsFMlBGQlNh2A+llS4uCKGywTGMVmIXloFsJDs5A8tICReRWjaGpBckFxUnqRiV5xYm5x
	aV66XnJ+7iZGYLyd/vdswg7GewesDzEmA22cyCwlmpwPjNe8knhDYzMjC1MTU2Mjc0sz0oSV
	xHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDsXcCSLfrLp+1ioCZr7oHQGFOOQ/ZK
	4WENf7X0dJgux5r933a84vO61H9PvurN/26kfcfD+8Dyso832a9cq1rgtzUpn485qa3svthK
	0TZWo9fvrmfpTnPvKnOQblwa8/PXig2rJcqMztVZLS7zKUqJWhm8vHwh827GZwb6jh0NfEWa
	2Wl2TEosxRmJhlrMRcWJAPTwXdLNAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jAd3YbWeDDW7eM7K4te4cq8WVr+/Z
	LF7cu8hicbbpDbvF5V1z2CxmnN/HZLH2yF12ixmTX7I5cHjc7z7O5NG3ZRWjx+dNcgHMUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJygplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYMzbsvM1UcE2g4s6iecwNjPt5uxg5
	OSQETCSeXlrBAmGLSVy4t56ti5GLQ0hgEaPEkdN7mEESvAKCEj8m3wMq4uBgFpCXOHIpGyTM
	LKAuMWneImaI+leMEvN6PjNB1GtJbPh+nhXEZhFQlfjZ8w4szgZkT1xxnw3EFhUIk3jxahfY
	fBGgQbNP3gEbxCxwhkni5IE1jCAJYYFoiTkPXzNBbGhmlFjz6yPYJE4BbYkpG06xTGAUmIXk
	wFkIB85CcuACRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHR/ExqB+PKBotDjAIcjEo8
	vBMUzwYLsSaWFVfmHmKU4GBWEuH90gwU4k1JrKxKLcqPLyrNSS0+xGgK9N5EZinR5Hxgoskr
	iTc0NjEzsjQyN7QwMjZXEuc90GodKCSQnliSmp2aWpBaBNPHxMEp1cCYddEqqlPafX6k86HS
	Q+dV1ZtM/c+emXrKhSvdx3qNJ/+TpXutdk5eZ73g9RI3Dr/jPStUfrG9ftl+341jbdqHzc9u
	LT0ncq5FZsYlFevcg5H2F/r/dppWfNCxy+jsPrG1XHD25Aihazohk3fcLXjHlavzLy/e2Uh6
	U6HP1g88gVMtjfUDOmyUWIozEg21mIuKEwFD6h80/AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 07월 21일 18:23, Andrzej Hajda wrote:
> Hi Inki,
> 
> On 07/09/2014 04:47 PM, Inki Dae wrote:
>> On 2014년 07월 03일 22:10, Andrzej Hajda wrote:
>>> This set of independent patches contains various improvement and fixes
>>> for exynos_drm ipp framework.
>>> The patchset is based on exynos-drm-next branch.
>>>
>> Did you test ipp module using libdrm? If so, can you share the app? I
>> would try to test this patch series before merging them. Mainline libdrm
>> has no any ipp interfaces.
> 
> I have used ipptest program developed by you :), with minor changes.
> More advanced tests are on my TODO list, but for this patchset ipptest
> seems to be OK - the patches are mainly cleanup patches.
> 


Did the ipptest work fine? I just tried to build the app so didn't test
the app. :) Got it, will merge this patch series.

Thanks,
Inki Dae

> Regards
> Andrzej
> 
>>
>> Thanks,
>> Inki Dae
>>
>>> Regards
>>> Andrzej
>>>
>>>
>>> Andrzej Hajda (12):
>>>   drm/exynos/ipp: remove type casting
>>>   drm/exynos/ipp: remove unused field from exynos_drm_ipp_private
>>>   drm/exynos/ipp: remove struct exynos_drm_ipp_private
>>>   drm/exynos/ipp: correct address type
>>>   drm/exynos/ipp: remove temporary variable
>>>   drm/exynos/ipp: remove incorrect checks of list_first_entry result
>>>   drm/exynos/ipp: simplify memory check function
>>>   drm/exynos/ipp: remove useless registration checks
>>>   drm/exynos/ipp: simplify ipp_find_obj
>>>   drm/exynos/ipp: remove redundant messages
>>>   drm/exynos/ipp: simplify ipp_create_id
>>>   drm/exynos/ipp: simplify ipp_find_driver
>>>
>>>  drivers/gpu/drm/exynos/exynos_drm_drv.h |   7 +-
>>>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 259 +++++++++-----------------------
>>>  drivers/gpu/drm/exynos/exynos_drm_ipp.h |   4 +-
>>>  3 files changed, 73 insertions(+), 197 deletions(-)
>>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

