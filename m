Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbaD2HgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:36:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57465 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaD2HgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:36:20 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-9a-535f5672eae8
Message-id: <535F5AA7.2050001@samsung.com>
Date: Tue, 29 Apr 2014 16:54:15 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com, chow.kim@samsung.com,
        yg1004.jang@samsung.com, vikas.sajjan@samsung.com,
        b.zolnierkie@samsung.com, Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RESUBMIT RFC PATCH v2 3/3] drivers: mfd: Add support for Exynos
 PMU driver
References: <1398687607-4554-1-git-send-email-pankaj.dubey@samsung.com>
 <1398687607-4554-4-git-send-email-pankaj.dubey@samsung.com>
 <20140428122646.GF21279@lee--X1>
In-reply-to: <20140428122646.GF21279@lee--X1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zfd2isPhgg8evdCw2zljParFs0l02
	i94FV9ks7n89ymix6fE1VovLu+awWcw4v4/J4vZlXovT3awWF1d8YbJYP+M1i8XNZ9uZLHa0
	rGZx4PVoae5h87hzbQ+bx7yTgR6bl9R79G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV0bXg/Xs
	Bb+UKi4+O8nSwPhEuouRk0NCwESi8fVaJghbTOLCvfVsXYxcHEICyxgl5k3rZ4IpWtJ8ghUi
	sYhRYumHLcwQzmtGidOr1jKDVPEKaEnMu3OIsYuRg4NFQFWi/4EDSJhNQFfiyfu5YCWiAmES
	m6b3sUKUC0r8mHyPBaRcREBF4twbc5CRzAIPmSS27zzBDlIjLBAlsfVqC1i9kMAKRolZC01A
	bE6gmd+XnGYDsZkFzCQetaxjhrDlJTaveQt2m4RAK4fElEmnwJpZBAQkvk0+BLZMQkBWYtMB
	ZojHJCUOrrjBMoFRbBaSk2YhGTsLydgFjMyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MUKi
	tncH4+0D1ocYk4FWTmSWEk3OB0Z9Xkm8obGZkYWpiamxkbmlGWnCSuK8SQ+TgoQE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwZr9j1Lz6ftqqsx0sxbLPRU4wrGS06ZvqsK4m7qODhV14zyLh
	qboZuT1yaetFQ1dpKe60frLA5IBrRkOsz6Sl8TdOHpK3t5iaOZvp6sLZohPVJVmfyE3Zucf2
	XeT6Qpdba09vyou4FqApyXzSwMy9MGRDuHfJPdcXB3zUiuasm/rOr1vOyqhUiaU4I9FQi7mo
	OBEAOve4gvACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jAd2isPhgg3lf1Sw2zljParFs0l02
	i94FV9ks7n89ymix6fE1VovLu+awWcw4v4/J4vZlXovT3awWF1d8YbJYP+M1i8XNZ9uZLHa0
	rGZx4PVoae5h87hzbQ+bx7yTgR6bl9R79G1ZxejxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtCZSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMrgfr2Qt+KVVcfHaSpYHxiXQXIyeHhICJxJLmE6wQtpjEhXvr
	2boYuTiEBBYxSiz9sIUZwnnNKHF61VpmkCpeAS2JeXcOMXYxcnCwCKhK9D9wAAmzCehKPHk/
	F6xEVCBMYtP0PlaIckGJH5PvsYCUiwioSJx7Yw4yklngIZPE9p0n2EFqhAWiJLZebQGrFxJY
	wSgxa6EJiM0JNPP7ktNsIDazgJnEo5Z1zBC2vMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECE4Jz6R3MK5qsDjEKMDBqMTD2xETFyzEmlhWXJl7iFGC
	g1lJhDffKj5YiDclsbIqtSg/vqg0J7X4EGMyMAAmMkuJJucD01VeSbyhsYmZkaWRmYWRibk5
	acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTCqvZC4bf2DMe3i2wsV1ttjZj9xM0s4ruAw
	eZ6qrFvZMQnnF71irus2/b25SFCM7Ui7vsf+u5Y7pVMzPztHyX8QfPzx+drdgopuW9fMcTNV
	2fbtiUfD9Cie0qtSR1nFfl55Ylqh/nOW43pxtS123GJBwuG2HA/zVnPtfsm8T3GjV5XewQUS
	4cuVWIozEg21mIuKEwEQkuj6TQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 09:26 PM, Lee Jones wrote:
>> This patch moves Exynos PMU driver implementation from
>> "arm/mach-exynos" to "drivers/mfd".
>> This driver is mainly used for setting misc bits of register from PMU IP
>> of Exynos SoC which will be required to configure before Suspend/Resume.
>> Currently all these settings are done in "arch/arm/mach-exynos/pmu.c" but
>> moving ahead for ARM64 based SoC support, there is a need of DT based
>> implementation of PMU driver.
>> This driver uses already existing DT binding information.
>>
>> CC: Sangbeom Kim <sbkim73@samsung.com>
>> CC: Samuel Ortiz <sameo@linux.intel.com>
>> CC: Lee Jones <lee.jones@linaro.org>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-exynos/Kconfig                           |    2 ++
>>   arch/arm/mach-exynos/Makefile                          |    2 --
>>   drivers/mfd/Kconfig                                    |    9 +++++++++
>>   drivers/mfd/Makefile                                   |    1 +
>>   arch/arm/mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c |    0
>>   5 files changed, 12 insertions(+), 2 deletions(-)
>>   rename arch/arm/mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c (100%)
> So I just took a look at the code as zero changes looks suspicious to
> me. The driver can not simply be copied and pasted into the MFD
> subsystem in its current state.
>
> The fundamental question is; is this chip actually an MFD? What does
> it do besides Power Management?

Exynos PMU chip controls different power states of Exynos, so mainly it
does power management related stuff. Apart from this it has few registers
which controls PHY of various IP blocks of Exynos such as USB, HDMI,
ADC etc. But these phy controlling register are currently being accessed
via "syscon" driver provided regmap APIs. For same the same reason
Exynos PMU has second compatibility string as "syscon".

>> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
>> index 2f60c90..79559b4 100644
>> --- a/arch/arm/mach-exynos/Kconfig
>> +++ b/arch/arm/mach-exynos/Kconfig
>> @@ -27,6 +27,7 @@ config ARCH_EXYNOS4
>>   	select PM_GENERIC_DOMAINS if PM_RUNTIME
>>   	select S5P_DEV_MFC
>>   	select MFD_SYSCON
>> +	select MFD_EXYNOS_PMU
>>   	help
>>   	  Samsung EXYNOS4 SoCs based systems
>>   
>> @@ -38,6 +39,7 @@ config ARCH_EXYNOS5
>>   	select HAVE_SMP
>>   	select PINCTRL
>>   	select MFD_SYSCON
>> +	select MFD_EXYNOS_PMU
>>   	help
>>   	  Samsung EXYNOS5 (Cortex-A15) SoC based systems
>>   
>> diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
>> index a656dbe..19fdf17 100644
>> --- a/arch/arm/mach-exynos/Makefile
>> +++ b/arch/arm/mach-exynos/Makefile
>> @@ -18,8 +18,6 @@ obj-$(CONFIG_PM_SLEEP)		+= pm.o sleep.o
>>   obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
>>   obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
>>   
>> -obj-$(CONFIG_ARCH_EXYNOS)	+= pmu.o
>> -
>>   obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
>>   
>>   obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index 3383412..fd48870 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -1203,6 +1203,15 @@ config MFD_STW481X
>>   	  in various ST Microelectronics and ST-Ericsson embedded
>>   	  Nomadik series.
>>   
>> +config MFD_EXYNOS_PMU
>> +	tristate "Support Exynos Power Managment Unit"
>> +	depends on ARM || ARM64
>> +	help
>> +	Exynos SoC have Power Management Unit (PMU) which controls power and
>> +	operation state of Exynos SoC in two different ways. This driver
>> +	provides impmentation of PMU driver and provides basic functionality
>> +	required during these operation state.
>> +
>>   menu "Multimedia Capabilities Port drivers"
>>   	depends on ARCH_SA1100
>>   
>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
>> index 2851275..7c43d07 100644
>> --- a/drivers/mfd/Makefile
>> +++ b/drivers/mfd/Makefile
>> @@ -166,3 +166,4 @@ obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
>>   obj-$(CONFIG_MFD_AS3711)	+= as3711.o
>>   obj-$(CONFIG_MFD_AS3722)	+= as3722.o
>>   obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
>> +obj-$(CONFIG_MFD_EXYNOS_PMU)	+= exynos-pmu.o
>> diff --git a/arch/arm/mach-exynos/pmu.c b/drivers/mfd/exynos-pmu.c
>> similarity index 100%
>> rename from arch/arm/mach-exynos/pmu.c
>> rename to drivers/mfd/exynos-pmu.c


-- 
Best Regards,
Pankaj Dubey

