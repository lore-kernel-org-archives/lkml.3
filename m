Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaDKGcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:32:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38414 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDKGcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:32:21 -0400
X-AuditID: cbfee690-b7f266d00000287c-fc-53478c73f841
Message-id: <53478C75.60302@samsung.com>
Date: Fri, 11 Apr 2014 15:32:21 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397122658-16013-2-git-send-email-cw00.choi@samsung.com>
 <20140411014650.GB14934@quad.lixom.net>
In-reply-to: <20140411014650.GB14934@quad.lixom.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkRLe4xz3Y4PJmK4vPH1rYLSbdn8Bi
	0bvgKpvF2aY37BabHl9jtbi8aw6bxYzz+5gsTl3/DGRNfslmsX7GaxaLvTsnMzpwe2xeUu9x
	5UQTq0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBlvDpzjLngpErF3nV7WRoY++W6GDk5JARM
	JJYuu8EEYYtJXLi3nq2LkYtDSGApo8SGJYtYYIomH7nGCpGYzihx5OoLJgjnNaPExLNLGEGq
	eAU0JE5f/gTWwSKgKtE7fzaYzSagJbH/xQ02EFtUIExi5fQrLBD1ghI/Jt8Ds0UElCWetF1i
	BhnKLDCFSeLuyw9gCWEBW4mTN+6zQGxbzSgxbedNVpAEJ9BN1/oPghUxC+hI7G+dxgZhy0ts
	XvMWbJKEwCN2id/Lj7NCnCQg8W3yIaAGDqCErMSmA8wQv0lKHFxxg2UCo9gsJEfNQjJ2FpKx
	CxiZVzGKphYkFxQnpReZ6BUn5haX5qXrJefnbmIERubpf88m7GC8d8D6EGMy0MqJzFKiyfnA
	yM4riTc0NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkY7
	XgFbrZXT+694KlcoqQRNn/oz5f6aPSUsnnoJ4h9eq60TfGXy6F3d1i3n4m0MwqO2CYTbPVKe
	826fMd8W/tmt0fmle145CO1RLJS9WnN3+1GeNdEn5IV/rb/0lSdxatUNj4adlU3KB43EFjl+
	irPSLGRPUX3z+r7HH3bxi7oSTE7Pps7k/K3EUpyRaKjFXFScCACvc81A4gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQd3iHvdgg99LDSw+f2hht5h0fwKL
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyOHX9M5A1+SWbxfoZr1ks9u6czOjA7bF5Sb3H
	lRNNrB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCX
	mJtqq+TiE6DrlpkDdJWSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePV
	mWPMBSdVKvau28vSwNgv18XIySEhYCIx+cg1VghbTOLCvfVsXYxcHEIC0xkljlx9wQThvGaU
	mHh2CSNIFa+AhsTpy59YQGwWAVWJ3vmzwWw2AS2J/S9usIHYogJhEiunX2GBqBeU+DH5Hpgt
	IqAs8aTtEjPIUGaBKUwSd19+AEsIC9hKnLxxnwVi22pGiWk7b4LdxAl037X+g2BFzAI6Evtb
	p7FB2PISm9e8ZZ7AKDALyZJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4
	7p9J72Bc1WBxiFGAg1GJh/fAJbdgIdbEsuLK3EOMEhzMSiK8Zv7uwUK8KYmVValF+fFFpTmp
	xYcYk4FhMJFZSjQ5H5iS8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSz
	hYmDU6qBUXTtV8VKx/lfy2XcWaN+uRjUvjEM+Ja2dNOhwv9+r19liTq5PMiem5C6e9Nb5y1t
	O0WvfF69U1w4fmay4mERocjbAQsbvH8/jZyaLK7zS9/SNETgSMyHqt8hZx5pFD6Yd1mzqaIq
	MnjxH+0PS3LeJz7mSHL1lghROfja88M6VlZ1/hXms7ckK7EUZyQaajEXFScCAIgVVZY/AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/11/2014 10:46 AM, Olof Johansson wrote:
> On Thu, Apr 10, 2014 at 06:37:12PM +0900, Chanwoo Choi wrote:
>> This patch add Exynos3250's SoC ID. Exynos 3250 is System-On-Chip(SoC) that
>> is based on the 32-bit RISC processor for Smartphone. Exynos3250 uses Cortex-A7
>> dual cores and has a target speed of 1.0GHz.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-exynos/Kconfig             | 22 ++++++++++++++++++++++
>>  arch/arm/mach-exynos/exynos.c            |  1 +
>>  arch/arm/plat-samsung/include/plat/cpu.h | 10 ++++++++++
>>  3 files changed, 33 insertions(+)
>>
>> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
>> index fc8bf18..6da8a68 100644
>> --- a/arch/arm/mach-exynos/Kconfig
>> +++ b/arch/arm/mach-exynos/Kconfig
>> @@ -11,6 +11,17 @@ if ARCH_EXYNOS
>>  
>>  menu "SAMSUNG EXYNOS SoCs Support"
>>  
>> +config ARCH_EXYNOS3
>> +	bool "SAMSUNG EXYNOS3"
>> +	select ARM_AMBA
>> +	select CLKSRC_OF
>> +	select HAVE_ARM_SCU if SMP
>> +	select HAVE_SMP
>> +	select PINCTRL
>> +	select PM_GENERIC_DOMAINS if PM_RUNTIME
>> +	help
>> +	  Samsung EXYNOS3 SoCs based systems
>> +
>>  config ARCH_EXYNOS4
>>  	bool "SAMSUNG EXYNOS4"
>>  	default y
>> @@ -41,6 +52,17 @@ config ARCH_EXYNOS5
>>  
>>  comment "EXYNOS SoCs"
>>  
>> +config SOC_EXYNOS3250
>> +	bool "SAMSUNG EXYNOS3250"
>> +	default y
>> +	depends on ARCH_EXYNOS3
>> +	select ARCH_HAS_BANDGAP
>> +	select ARM_CPU_SUSPEND if PM
>> +	select PINCTRL_EXYNOS
>> +	select SAMSUNG_DMADEV
>> +	help
>> +	  Enable EXYNOS3250 CPU support
>> +
>>  config CPU_EXYNOS4210
>>  	bool "SAMSUNG EXYNOS4210"
>>  	default y
>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
>> index b32a907..b134868 100644
>> --- a/arch/arm/mach-exynos/exynos.c
>> +++ b/arch/arm/mach-exynos/exynos.c
>> @@ -370,6 +370,7 @@ static void __init exynos_dt_machine_init(void)
>>  }
>>  
>>  static char const *exynos_dt_compat[] __initconst = {
>> +	"samsung,exynos3250",
> 
> Please consider samsung,exynos3 instead, so you don't have to update this table
> for every SoC. We've talked about this before..

This patchset included only exynos3250.dtsi without exynos3.dtsi.
So, I added only "samsung,exynos3250" compatible name.

Do you prefer to add SoC version as following?
+       "samsung,exynos3",
+       "samsung,exynos3250",

or ?
+       "samsung,exynos3",

> 
>>  	"samsung,exynos4",
>>  	"samsung,exynos4210",
>>  	"samsung,exynos4212",
>> diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
>> index 5992b8d..3d808f6b 100644
>> --- a/arch/arm/plat-samsung/include/plat/cpu.h
>> +++ b/arch/arm/plat-samsung/include/plat/cpu.h
>> @@ -43,6 +43,9 @@ extern unsigned long samsung_cpu_id;
>>  #define S5PV210_CPU_ID		0x43110000
>>  #define S5PV210_CPU_MASK	0xFFFFF000
>>  
>> +#define EXYNOS3250_SOC_ID       0xE3472000
>> +#define EXYNOS3_SOC_MASK        0xFFFFF000
>> +
>>  #define EXYNOS4210_CPU_ID	0x43210000
>>  #define EXYNOS4212_CPU_ID	0x43220000
>>  #define EXYNOS4412_CPU_ID	0xE4412200
>> @@ -68,6 +71,7 @@ IS_SAMSUNG_CPU(s5p6440, S5P6440_CPU_ID, S5P64XX_CPU_MASK)
>>  IS_SAMSUNG_CPU(s5p6450, S5P6450_CPU_ID, S5P64XX_CPU_MASK)
>>  IS_SAMSUNG_CPU(s5pc100, S5PC100_CPU_ID, S5PC100_CPU_MASK)
>>  IS_SAMSUNG_CPU(s5pv210, S5PV210_CPU_ID, S5PV210_CPU_MASK)
>> +IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS3_SOC_MASK)
>>  IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
>>  IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
>>  IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
>> @@ -126,6 +130,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
>>  # define soc_is_s5pv210()	0
>>  #endif
>>  
>> +#if defined(CONFIG_SOC_EXYNOS3250)
>> +# define soc_is_exynos3250()    is_samsung_exynos3250()
>> +#else
>> +# define soc_is_exynos3250()    0
>> +#endif
> 
> In general, I think we have too much code littered with soc_is_<foo>() going
> on, so please try to avoid adding more for this SoC. Especially in cases where
> you just want to bail out of certain features where we might already have
> function pointers to control if a function is called or not, such as the
> firmware interfaces.
> 

Do you prefer dt helper function such as following function instead of new soc_is_xx() ?
- of_machine_is_compatible("samsung,exynos3250")

If you are OK, I'll use of_machine_is_compatible() instead of soc_is_xx().

Best Regards,
Chanwoo Choi

