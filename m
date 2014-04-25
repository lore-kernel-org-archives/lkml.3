Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaDYFD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:03:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31996 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaDYFDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:03:24 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-4f-5359ec9a0d3a
Message-id: <5359EC99.2010107@samsung.com>
Date: Fri, 25 Apr 2014 14:03:21 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
Cc: kgene.kim@samsung.com, t.figa@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org, arnd@arndb.de,
        olof@lixom.net, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        sachin.kamat@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCHv4 7/7] ARM: dts: Add device tree sources for Exynos3250
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
 <1398388572-30239-8-git-send-email-cw00.choi@samsung.com>
 <5359E6DD.6000608@linaro.org>
In-reply-to: <5359E6DD.6000608@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsWyRsSkUHfWm8hgg5dbZCz+TjrGbrFxxnpW
	i0nrDjBZXN6vbTH/yDlWi/43C1ktPn9oYbc492olo8Wk+xNYLG78amO16F1wlc3ibNMbdotN
	j6+xWlzeNYfNYsb5fUwWty/zWvy984/NYun1i0wWp65/ZrOYMH0ti0Xr3iPsFif/9DJaPDn8
	kdVixuSXbBbrZ7xmsTg2YwmjRfvfvWwWe3dOZnSQ8Vgzbw2jR0tzD5vH71+TGD0u9/Uyefxd
	9YLZY+esu+weK5d/YfPYtKqTzePOtT1sHpuX1HtcOdHE6tG3ZRWjx+dNcgG8UVw2Kak5mWWp
	Rfp2CVwZO3+2MxXMZK14fesSawPjDJYuRk4OCQETifcX77ND2GISF+6tZ+ti5OIQEljKKHF1
	4g64ogl7H7FAJKYzSqxePh/Kec0o8ePUW7B2XgEtib1vL4LZLAKqEu/OrmQEsdmA4vtf3GAD
	sUUFwiRWTr/CAlEvKPFj8j0wW0RAR+LBor1gQ5kF5rFJfL48B6xBWMBb4umCk4wQ2xYyStx5
	9QFsAyfQ1PMz+sFsZqDu/a3T2CBseYnNa94ygzRICMzmlNj07zozxEkCEt8mHwJawQGUkJXY
	dIAZ4jdJiYMrbrBMYBSbheSoWUjGzkIydgEj8ypG0dSC5ILipPQiI73ixNzi0rx0veT83E2M
	wMR0+t+zvh2MNw9YH2JMBlo5kVlKNDkfmNjySuINjc2MLExNTI2NzC3NSBNWEudd9DApSEgg
	PbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj98EOZdEl3qEf1J6fVUm8pCjMeO/EajnbPzkJrybk
	Mm3S0AqKalm6voHt+tKa0q70MDb2StmJVj+YqzXbeA9GvagUm61omdA01eXXCiGmIL/3HVMi
	FRgfVjxeKSLDyali3K5fUeoptPZgUPrRJonq3gkvZj42tZw8rVJV1+zPm7hn/kbTbZRYijMS
	DbWYi4oTAcs5jnBiAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSe0hTYRjG+XbO+TalwWllndZNjgRhzdwyfaULRWEnLLA0y/6x0zyp5TbZ
	0cgiGuYKK3Vp5FrhjcK2VpIWZLUsEyvLbiuTMruH5ezCulpKc1ZI/dX31+97eJ73gZdXRiic
	WClL12cJRj2fweJA8lr/8+EqmycpPnyXdQT0FTdL4YS1hoLi4xck4G6YAuVNNygo8lRS4H2f
	J4Ubb+wIih9bSGjv3U5BQcU9DK25HinUPm+jwH3mIAbrzfMSeOiWQ19HP4bD929LoOW+F4Ol
	9BgJZleTFK7+KEDw4tIHCqwlrzHUWLtJaLYeQrCjz4XBVV+C5o7jnGVOxOVt2425773FiHMX
	Fki4PkcXwdXbHkk5e/VHzNU68jHX0XYOc3WHtnJ3r+RSXOFJB+K8tRPi5KtMaFaawKcIxmBB
	rzWkpOtTZ7Ox8cnzk2dEhqtV6miIYoP1vE6YzS5YHKeKSc/wbYUN3sBnZPukOF4U2Wlz/p2w
	PCFGBb+DK1VLEpb9yWjC/3qrnSit/tsOSeZ+amP3gzuUCVnJnShAxtARjMX17BePYm511uCd
	KFCmoEsRc7S6nBz8dCPma0uPdMAlp0MZV89tP5P0JOZtqx0NMPbpDV3teICD6ETGXnqXHPQP
	Z76WdPp5JD2VeVLl8g8l6DLMeN0H/YERdCzzsuIqGmyrREzHm/f+hgDf1JvWIj8TvnSDeR8e
	5IlMnbOHsCDaNqTENsRmG2KrQIQDBQmZ2kxxTapOEybyOjFbnxqmNehqkf/2Xo09jRwmaES0
	DLHD5JbxSfEKit8g5ugaESMj2JHyEIdPkqfwOZsEoyHZmJ0hiI1I69vBHkIZpDX4Llmflaye
	HhGpidZEqUEzPer/ZHa0/KJ55lIFncpnCesFIVMw/m6RyAKUJnSidaH71LzQQFoV+QB9Cck9
	3lvlaieVzR/Nt+7Eppujt+Tpv7TVHK64Vnh2vLJrRchyjyTsc1vR5smahLJl8LlpjGguT5nv
	zt8alvj0yTAVuWqP4brJ4q0OPdA+pv/Iu32ecWcSp6y7HBHTkLs3Z6Klcy33KVDSP+p0h6Fl
	UUy+XcGSYhqvDiWMIv8TFpInFb8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 01:38 PM, Tushar Behera wrote:
> On 04/25/2014 06:46 AM, Chanwoo Choi wrote:
>> From: Tomasz Figa <t.figa@samsung.com>
>>
>> This patch add new exynos3250.dtsi to support Exynos3250 SoC based on Cortex-A7
>> dual core and includes following dt nodes:
>>
> 
> [ ... ]
> 
>> ---
>>  arch/arm/boot/dts/exynos3250-pinctrl.dtsi | 477 +++++++++++++++
>>  arch/arm/boot/dts/exynos3250.dtsi         | 405 +++++++++++++
>>  arch/arm/boot/dts/exynos4212-tizenw.dts   | 926 ++++++++++++++++++++++++++++++
> 
> exynos4412-tizenw.dts related changes are unrelated.


Right, It is may mistake.
I'll resend this patch.

Thanks,
Chanwoo Choi

