Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaDXMjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:39:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13446 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaDXMjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:39:44 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-7b-5359060e7d37
Message-id: <53590A3D.1020308@samsung.com>
Date: Thu, 24 Apr 2014 21:57:33 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Vikas Sajjan <sajjan.linux@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        Kukjin Kim <kgene.kim@samsung.com>, linux@arm.linux.org.uk,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        Rob Herring <robh+dt@kernel.org>, galak@codeaurora.org,
        chow.kim@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH 1/3] ARM: dts: Add PMU reg node to exynos4210
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425778-4379-2-git-send-email-pankaj.dubey@samsung.com>
 <CAGm_ybjfxprtLUX6Vs8QVvXoMOaHez4-Og8a9n3UevibvmzbZA@mail.gmail.com>
In-reply-to: <CAGm_ybjfxprtLUX6Vs8QVvXoMOaHez4-Og8a9n3UevibvmzbZA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zA10+tshgg6nPjC2WTbrLZjH/yDlW
	i/43C1ktzr1ayWjxfdcXdoveBVfZLDY9vsZqcXnXHDaLGef3MVncvsxrsfT6RSaLCdPXsli0
	7j3CbvHk8EdWi/UzXrNYrNr1h9FBwGPNvDWMHi3NPWwel/t6mTx2zrrL7rFy+Rc2j02rOtk8
	Ni+p9+jbsorR4/MmuQDOKC6blNSczLLUIn27BK6M4wd/shU8Fqp49WgpewPjbb4uRk4OCQET
	icXTL7JC2GISF+6tZ+ti5OIQEljGKPGm9w4bTNH0o5vYIRLTGSXuvT7PDOG8ZpRoeNkJVsUr
	oCWx/MtLsFEsAqoSB7teg9lsAroST97PZQaxRQXCJDZN72OFqBeU+DH5HksXIweHiICmxMOP
	NiBhZoFeFokvjaogtrCAo0T/1pVgrUICZxglVk1hArE5BYIlHt+czQxRbybxqGUdlC0vsXnN
	W7DbJAS2cEicPzmfDeIeAYlvkw+B7ZIQkJXYdIAZ4jFJiYMrbrBMYBSbheSiWUjGzkIydgEj
	8ypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkKjv38F494D1IcZkoJUTmaVEk/OBSSOvJN7Q
	2MzIwtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDKazfEq69d
	4t7h903/zQ1Gi5lN9bqy+f9YWzxXef7zkmfq//DMSVJxzcxQvxe/YmwbU3cViO1Tf6GbuPpm
	YJF+8IwW8V+/3v0v9Nnxkc3wxc0lJ2ZzTXn9rGnV1SiNcw/m/JnA8LTt9o6MxKvNIlM8u3Z/
	F7lyREmN3eqRndXXZX+ulNmsmVOmxFKckWioxVxUnAgASFeFMxADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jQV0+tshgg433dC2WTbrLZjH/yDlW
	i/43C1ktzr1ayWjxfdcXdoveBVfZLDY9vsZqcXnXHDaLGef3MVncvsxrsfT6RSaLCdPXsli0
	7j3CbvHk8EdWi/UzXrNYrNr1h9FBwGPNvDWMHi3NPWwel/t6mTx2zrrL7rFy+Rc2j02rOtk8
	Ni+p9+jbsorR4/MmuQDOqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygN5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGccP
	/mQreCxU8erRUvYGxtt8XYycHBICJhLTj25ih7DFJC7cW8/WxcjFISQwnVHi3uvzzBDOa0aJ
	hpedbCBVvAJaEsu/vGQFsVkEVCUOdr0Gs9kEdCWevJ/LDGKLCoRJbJrexwpRLyjxY/I9li5G
	Dg4RAU2Jhx9tQMLMAr0sEl8aVUFsYQFHif6tK8FahQTOMEqsmsIEYnMKBEs8vjmbGaLeTOJR
	yzooW15i85q3zBMYBWYh2TALSdksJGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSn
	lGfSOxhXNVgcYhTgYFTi4VW4FR4sxJpYVlyZe4hRgoNZSYR39r+IYCHelMTKqtSi/Pii0pzU
	4kOMycAAmMgsJZqcD0x3eSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZ
	wsTBKdXA2Hbd+sC5jS2Lf7B8djqaNu20nK901pVbAi7zPvad3SXgPifvVcWj30ef7JLpezB5
	nshh02/vXutdFwh8/6kwXbn4vlfr6rcMrwovuGbMXrDzcevHHMEPqi0FMmus+tI0nixLZJz2
	x3l7dr5lrsiyswIO5+y3LruTfc+U64FEScm2L2nT1A6tMFJiKc5INNRiLipOBAAA5cKvbQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vikas,

On 04/24/2014 08:59 PM, Vikas Sajjan wrote:
> +Tomasz
>
>
> On Wed, Apr 2, 2014 at 1:32 PM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
>> This patch adds pmu regnode to exynos4210 dtsi to handle
>> PMU register access via DT.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/boot/dts/exynos4210.dtsi |    5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
>> index cacf614..0a2c0fe 100644
>> --- a/arch/arm/boot/dts/exynos4210.dtsi
>> +++ b/arch/arm/boot/dts/exynos4210.dtsi
>> @@ -81,6 +81,11 @@
>>                  interrupts = <2 2>, <3 2>;
>>          };
>>
>> +       pmu_system_controller: system-controller@10020000 {
>> +               compatible = "samsung,exynos4210-pmu", "syscon";
>> +               reg = <0x10020000 0x5000>;
> Can we have 2 strings as "compatible" and these 2 strings are used by
> 2 different driver?
>
> Because once syscon driver gets probed, exynos-pmu.c [1] driver will
> never be probed.
>
> The new PMU driver [1] completely relies on this. With just
> exynos_defconfig, you will not notice this issue, since syscon is NOT
> enabled by exynos_defconfig. When I enabled "System Controller
> Register R/W Based on Regmap" in menuconfig, I could see PMU driver
> [1] is NEVER probed.
>
> Let me know, if I am missing something.
>
>   [1] http://www.spinics.net/lists/arm-kernel/msg319750.html

You are correct. We also missed this because "SYSCON" option was
not enabled in exynos_defconfig.
I noticed this during preparation of V2 when I planned to use
"early_syscon_init" [1] as suggested by Sylwester here [2].

In V2 I will take care of this. I hope soon I will be able to post second
version of this series, just waiting for testing and internal code review.

[1] https://lkml.org/lkml/2014/4/8/239
[2] https://lkml.org/lkml/2014/4/2/171
>
>
>> +       };
>> +
>>          pinctrl_0: pinctrl@11400000 {
>>                  compatible = "samsung,exynos4210-pinctrl";
>>                  reg = <0x11400000 0x1000>;
>> --
>> 1.7.10.4
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


-- 
Best Regards,
Pankaj Dubey

