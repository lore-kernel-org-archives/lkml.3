Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaDKAog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:44:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17040 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaDKAoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:44:32 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-31-53473aee2d1d
Message-id: <53473AF0.1060103@samsung.com>
Date: Fri, 11 Apr 2014 09:44:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 08/27] pinctrl: exynos: Add driver data for Exynos3250
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
 <1397122124-15690-9-git-send-email-cw00.choi@samsung.com>
 <CACRpkdYiFCHFifkpRwDhdAGqBrGTU5E4mfdGE8u1c=zrim17aA@mail.gmail.com>
 <5346EE5A.3070408@gmail.com>
In-reply-to: <5346EE5A.3070408@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsWyRsSkSPe9lXuwwRc/i88fWtgtJt2fwGLR
	u+Aqm8XZpjfsFlP+LGey2PT4GqvF5V1z2CxmnN/HZDFj8ks2i/UzXrNYrNr1h9Fi787JjA48
	Hjtn3WX3uHNtD5vH5iX1Hn1bVjF6fN4kF8AaxWWTkpqTWZZapG+XwJXRuXMxe8EBjooHu3+x
	NDC+Yuti5OSQEDCRmNt5mwXCFpO4cG89UJyLQ0hgKaPE3zcNrDBF134tBGsQEljEKDFrpT1E
	0WtGiWWf9zCDJHgFtCT+3b8BZrMIqEpsXPMXrJkNKL7/xQ2wZlGBMImV06+wQNQLSvyYfA/M
	FhFQl/g2pZ8dZCizwGlmif8PD4A1Cwt4SWxYd4kZYttzRonmPQ/AOjgFNCU+T70CVsQsoCOx
	v3UaG4QtL7F5zVuwBgmBj+wSrc/PsEOcJCDxbfIhoGYOoISsxKYDzBCvSUocXHGDZQKj2Cwk
	R81CMnYWkrELGJlXMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgRG6ul/z3p3MN4+YH2IMRlo
	5URmKdHkfGCk55XEGxqbGVmYmpgaG5lbmpEmrCTOm/QwKUhIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDo3Lgx4lyL7LE649uubym8tNEnxfpBgt6Iq4tnq/z/nRbSnH2Nbb3Z2tyYlb1RwqU
	Pao79e7cLwkezhOXs0423+5e7dLtsajTI/+FTYDoAfN4oeW3goVjLp2749d1c3HqnmDdhy15
	F/zSRL4dyTbYrHgp+vyi1QFKfAociXN+PNxhLnx84cU5UUosxRmJhlrMRcWJADNyuYPqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd13Vu7BBpOemlh8/tDCbjHp/gQW
	i94FV9kszja9YbeY8mc5k8Wmx9dYLS7vmsNmMeP8PiaLGZNfslmsn/GaxWLVrj+MFnt3TmZ0
	4PHYOesuu8eda3vYPDYvqffo27KK0ePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4
	UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoPuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqG
	BMH1GBmggYQ1jBmdOxezFxzgqHiw+xdLA+Mrti5GTg4JAROJa78WQtliEhfurQezhQQWMUrM
	WmnfxcgFZL9mlFj2eQ8zSIJXQEvi3/0bYDaLgKrExjV/WUFsNqD4/hc3wJpFBcIkVk6/wgJR
	LyjxY/I9MFtEQF3i25R+dpChzAKnmSX+PzwA1iws4CWxYd0lZohtzxklmvc8AOvgFNCU+Dz1
	ClgRs4COxP7WaWwQtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07MLS7N
	S9dLzs/dxAhOBM+kdzCuarA4xCjAwajEw3vgkluwEGtiWXFl7iFGCQ5mJRHenh9AId6UxMqq
	1KL8+KLSnNTiQ4zJwDCYyCwlmpwPTFJ5JfGGxiZmRpZG5oYWRsbmpAkrifMebLUOFBJITyxJ
	zU5NLUgtgtnCxMEp1cAY0KQt0PnP5tAl5VD/vZ1usxRPfjBVcHpwdX2wrGv6L01VHZUoxydO
	ec4dV93qEqZub9kQcFHvhzePQ5ZQy957mSnRk95/cVffcCLNaL8c3/Nt7xq6l+yJYri6iWNi
	49eo60o3llrNsZk35cHbjLxAm9Rfe6Zs0zKYeMszb0fQ4fLNr6LCQm4osRRnJBpqMRcVJwIA
	0Y6f9EgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

On 04/11/2014 04:17 AM, Tomasz Figa wrote:
> Hi,
> 
> On 10.04.2014 20:42, Linus Walleij wrote:
>> On Thu, Apr 10, 2014 at 11:28 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>
>>> From: Tomasz Figa <t.figa@samsung.com>
>>>
>>> This patch adds driver data (bank list and EINT layout) for Exynos3250
>>> to pinctrl-exynos driver. Exynos3250 includes 158 multi-functional input/output
>>> ports. There are 23 general port groups.
>>>
>>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> Ugh can Tomasz send out his patches himself, I get confused...
>> It was also sent two times, the second time with CC:s added.
>> Tomasz, shall I merge this?
> 
> I'm fine with this patch being sent by Chanwoo, although he should have probably added his sign-off to the list, as the person sending it.
> 
> Chanwoo, can you make sure that there is your sign-off on all the patches from this series?
> 

OK, I'll add my sign-off to all the patches on next posting(v2).

Best Regards,
Chanwoo Choi

