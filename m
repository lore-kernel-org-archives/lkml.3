Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbbASKYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:24:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:23247 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbbASKYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:24:34 -0500
X-AuditID: cbfee691-f79b86d000004a5a-10-54bcdb60dd2d
Message-id: <54BCDB60.1020509@samsung.com>
Date: Mon, 19 Jan 2015 19:24:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, tglx@linutronix.de, inki.dae@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>
Subject: Re: [RESEND PATCH v3] clocksource: exynos_mct: Add the support for
 Exynos 64bit SoC
References: <1421213603-5020-1-git-send-email-cw00.choi@samsung.com>
 <54B69072.4080607@kernel.org> <54B692FB.7030703@linaro.org>
 <54BC55BB.7050809@samsung.com> <54BCCE16.8050607@linaro.org>
In-reply-to: <54BCCE16.8050607@linaro.org>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsWyRsSkRDfh9p4Qg119ShbzPstanF12kM1i
	0v0JLBa9C66yWfQ/fs1ssenxNVaLy7vmsFnMOL+PyWLp9YtMFqeuf2azePR0JZPF5k1TmS1+
	7prH4sDrsWbeGkaP2Q0XWTx2zrrL7rFpVSebx51re9g83p07x+6xeUm9x5UTTawevc3v2Dz6
	tqxi9Pi8SS6AO4rLJiU1J7MstUjfLoErY+bHU2wFswUqWqb/YGlg/MTTxcjJISFgInFp3WFm
	CFtM4sK99WxdjFwcQgJLGSXWfvjEClP09cM5FojEIkaJTWs/MUI4rxklru29zwRSxSugJbHs
	+jmwDhYBVYmGM4/BxrIBxfe/uMEGYosKhEmsnH6FBaJeUOLH5HtgtoiAnkTj+zYmkKHMAguY
	JX6+62MHSQgLxEn8PrIZavVBRom+T9cYQRKcQFP/LT0LtplZQF1i0rxFzBC2vMTmNW+ZQRok
	BJZySBy6PY8F4iQBiW+TDwHZHEAJWYlNB6CelpQ4uOIGywRGsVlIjpqFZOwsJGMXMDKvYhRN
	LUguKE5KLzLVK07MLS7NS9dLzs/dxAiM+NP/nk3cwXj/gPUhRgEORiUe3o2+e0KEWBPLiitz
	DzGaAl0xkVlKNDkfmFbySuINjc2MLExNTI2NzC3NlMR5daR/BgsJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgnKg+xzZ05gvH3y66G2Ve3397XL5YnaXitZN/qv53hjcTb05tfX9Mm6H8ncm1
	lV7bWI2XNz4XVtK4fcItuPfTryq/MxLzFPco2Fm593NHz337+F1T3Buu46/S/9W+rS0LjeaQ
	bC4NEpv7JCQ0kUeBRenKYTPvu+/FDd6vfeKSu3fBROZLUZPMlViKMxINtZiLihMBaNZKXPMC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd2E23tCDJ7ukrSY91nW4uyyg2wW
	k+5PYLHoXXCVzaL/8Wtmi02Pr7FaXN41h81ixvl9TBZLr19ksjh1/TObxaOnK5ksNm+aymzx
	c9c8FgdejzXz1jB6zG64yOKxc9Zddo9NqzrZPO5c28Pm8e7cOXaPzUvqPa6caGL16G1+x+bR
	t2UVo8fnTXIB3FENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QB8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDNmfjzFVjBb
	oKJl+g+WBsZPPF2MnBwSAiYSXz+cY4GwxSQu3FvP1sXIxSEksIhRYtPaT4wQzmtGiWt77zOB
	VPEKaEksu36OFcRmEVCVaDjzmBnEZgOK739xgw3EFhUIk1g5/QoLRL2gxI/J98BsEQE9icb3
	bUwgQ5kFFjBL/HzXxw6SEBaIk/h9ZDMLxLaDjBJ9n64xgiQ4gab+W3oWbDOzgLrEpHmLmCFs
	eYnNa94yT2AUmIVkySwkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZxOnknt
	YFzZYHGIUYCDUYmHlyNgT4gQa2JZcWXuIUYJDmYlEV7GC0Ah3pTEyqrUovz4otKc1OJDjKbA
	MJjILCWanA9MdXkl8YbGJmZGlkbmhhZGxuZK4rxK9m0hQgLpiSWp2ampBalFMH1MHJxSDYxR
	ne//CkS3iZnxh72Rv/G+4X662JvGxo/u78+GcM3js3YP8Ho5o993zVEztt/L5vUzxNrK6U2r
	nPHoVvn5qD0Py1xObsmQ+RN/9rPGt13a7/dcdE3oyN0fbb+H0efVR1HHJI01729uFLlbLKET
	n75OelF0aMda4WU7/jm+sFL53MpZVB2c/E6JpTgj0VCLuag4EQBhFy21PQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 01/19/2015 06:27 PM, Daniel Lezcano wrote:
> On 01/19/2015 01:54 AM, Chanwoo Choi wrote:
>> Dear Daniel and Kukjin,
>>
>> On 01/15/2015 01:02 AM, Daniel Lezcano wrote:
>>> On 01/14/2015 04:51 PM, Kukjin Kim wrote:
>>>> On 01/14/15 14:33, Chanwoo Choi wrote:
>>>>
>>>> Hi,
>>>>
>>>> + Doug, Olof
>>>>
>>>>> This patch adds the support for Exynos 64bit SoC. The delay_timer is only used
>>>>> for Exynos 32bit SoC.
>>>>>
>>>> Yes, the Exynos MCT(Multi-Core Timer) is 64bit timer and it is available
>>>> on 64bit exynos SoC such as exynos7. But basically ARMv8 architecture is
>>>> including ARM ARCH timer (ARM Generic Timer) and exynos7 also has
>>>> implemented it and additionally its access is faster than using memory
>>>> mapped register called SFR for MCT...so Doug submitted patch to use MCT
>>>> on 32bit exynos SoCs before.
>>>>
>>>> I know using MCT on 64bit exynos is usefulness for Power Management and
>>>> I need to talk to relevant guys in office again. If anything, I'll let
>>>> you know.
>>>
>>> I will wait for your answer before digging more the patch.
> 
> Hi Chanwoo,
> 
> [ ... ]
> 
>> Do you have any comment about this patch?
> 
> Yes, a similar patch has been posted for the tegra2 timer to run on arm64. The patch in question put macros #ifdef CONFIG_ARM64 to disable some parts of the code. That ended, the tegra2 timer was not needed for the moment because of the arch timer present, so it has been disabled from the compilation until a proper fix without macros could be proposed.
> 
> It is happening exactly the same with this patch. As Kukjin pointed it, the exynos_mct may not be needed (at least until a backup timer is needed at PM time).
> 
> I suggest you look at a nicer way to fix that instead of introducing macros (which is by the way valid but not recommended by the CodingStyle rules) and perhaps sync with Paul and Thierry [cc'ed] to find a common solution.

OK, I understand your opinion. I'll try to consider it without adding '#ifdef'.

Best Regards,
Chanwoo Choi

