Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbbALKSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:18:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14092 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbbALKSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:18:32 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-22-54b39f665aaa
Date: Mon, 12 Jan 2015 10:18:14 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCHv7 00/10] devfreq: Add devfreq-event class to provide
 raw data for devfreq device
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150112101805307@myungjoo.ham
Msgkey: 20150112101805307@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150112101805307@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <948926965.905951421057891449.JavaMail.weblogic@epmlwas01a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkSDdt/uYQgynftSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG+/ot7AXXBCuWr3nI2MA4Q7CLkZNDSEBdYtGSk2wgtoSAiUTb
	ueesELaYxIV764HiXEA1SxklPt08zApTtHPbehaIxBxGia+7djOBJFgEVCWaGnYzdzFycLAJ
	6EnM/JwMEhYWyJC42/SCEcQWESiWuHV0IitIL7NAO5vEtlXnWCGuUJJYs+8VC4jNKyAocXLm
	ExaIZaoS0163MkLE1ST2PbwIFReXuDD3EjuEzSsxo/0pVFxOYtrXNcwQtrTE+VkbGGG+Wfz9
	MVScX+LY7R1MELaAxNQzB6FqtCQe738D9SSfxJqFb1lg6nedWs4Ms+v+lrlQvRISW1uegNUz
	CyhKTOl+yA7yO7OApsT6XfroXuEVcJe4teEhVOtUDomm3U4TGJVmISmbhWTSLIRJyEoWMLKs
	YhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAhMC6f/PZuwg/HeAetDjAIcjEo8vBZSm0OEWBPL
	iitzDzGaAiNpIrOUaHI+MPnklcQbGpsZWZiamBobmVuaKYnzvpb6GSwkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBUSx12twZnFe+tk2frpF7N3up3OKTa+umrnsRFHDkr4el3KslEjJPluyT
	ENJf8Vd8EneP0+6vLL2m9c0zwj7q1V0w/CmsW9G/xlRk/hO90y189ouijH9d8N+UrlVouHhO
	wLJA/9/Sm13uzm4Mrzzv+WTq3/9M6WebUmZ2H5tp+EHr6f3iT4vZHJVYijMSDbWYi4oTAW2p
	v2QGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t/tPt20+ZtDDLadUra4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRnt
	67ewF1wTrFi+5iFjA+MMwS5GTg4hAXWJRUtOsoHYEgImEju3rWeBsMUkLtxbDxTnAqqZwyjx
	ddduJpAEi4CqRFPDbuYuRg4ONgE9iZmfk0HCwgIZEnebXjCC2CICxRK3jk5kBellFmhnk9i2
	6hwrxDIliTX7XoEt4BUQlDg58wnUMlWJaa9bGSHiahL7Hl6EiotLXJh7iR3C5pWY0f4UKi4n
	Me3rGmYIW1ri/KwNjDBHL/7+GCrOL3Hs9g4mCFtAYuqZg1A1WhKP979hhbD5JNYsfMsCU7/r
	1HJmmF33t8yF6pWQ2NryBKyeWUBRYkr3Q3aQ35kFNCXW79JH9wqvgLvErQ0PmSYwys5CkpqF
	pHsWQjeykgWMLKsYRVMLkguKk9IrjPWKE3OLS/PS9ZLzczcxgpPQs8U7GP+ftz7EKMDBqMTD
	ayG1OUSINbGsuDL3EKMEB7OSCK9rGVCINyWxsiq1KD++qDQntfgQoykwziYyS4km5wMTZF5J
	vKGxsYmZiamliYWBqbmSOO//c7khQgLpiSWp2ampBalFMH1MHJxSDYx+B94Ji+xX4c9dLrnt
	HluG6AqV+sKyyQxMU2ZYPo7b+nTCvbPCTNNqFOSt9E4I6xSZl/qHzCs/fHPaxf3N2r577I8d
	2bkxQ26dSNAz+2yZd8ya89X3f5zIKMbesk7lqJ6AT79r0s1Drb9fbV0lurD1Qs12TimN95LV
	ixjCVvo+Z+zze+jyo0uJpTgj0VCLuag4EQC91qNqWAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0CAIg8K017331

>  
> On 01/12/2015 06:58 PM, MyungJoo Ham wrote:
>>>   
>>>  This patchset add new devfreq_event class to provide raw data to determine
>>> current utilization of device  which is used for devfreq governor.
>>>
>>> The following description explains the feature of two kind of devfreq class:
>>> - devfreq class (existing)
>>>  : devfreq consumer device use raw data from devfreq_event device for
>>>    determining proper current system state and change voltage/frequency
>>>    dynamically using various governors.
>>> - devfreq_event class (new)
>>>  : Provide measured raw data to devfreq device for governor
>>>
>> 
>> Question: Applying this patchset seems to imply that
>> drivers/devfreq/exynos/exynos_ppmu.c becomes obsolete.
>> How do you want to address it? Do you think it'd be ok to remove
>> thse obsolete drivers after your successing patchset?
>> 
>> If it is ok to remove old drivers after applying the new patchset,
>> please inclde a patch that removes old drivers unless such a removal
>> might result in compatibility issues with old (yet another obsolete)
>> board files, which I don't think probable.
>
>I agree to remove 'drviers/devfreq/exynos/exynos_ppmu.c.
>But, existing exynos_ppmu.c was used for drivers/devfreq/exynos/exynos5_bus.c.
>
>Before removing existing 'exynos_ppmu.c', might need to test the devfreq-event class
>on Exynos5260 SoC. I will just remove old driver('drivers/devfreq/exynos/exynos4_bus.{c|h}')
>on next patchset.

That's fine with me.


Cheers,
MyungJoo

>
>To Abhilash,
>Could you test this patch-set on Exynos5260 SoC?
>
>Best Regards,
>Chanwoo Choi
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
