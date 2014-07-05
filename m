Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbaGEGdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 02:33:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48856 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaGEGde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 02:33:34 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-df-53b79c3cc7fc
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
 <1403705032-14835-3-git-send-email-pankaj.dubey@samsung.com>
 <53B18E24.70809@samsung.com>
In-reply-to: <53B18E24.70809@samsung.com>
Subject: RE: [PATCH v5 2/5] ARM: EXYNOS: Refactored code for using PMU address
 via DT
Date: Sat, 05 Jul 2014 12:04:10 +0530
Message-id: <001c01cf981b$25138950$6f3a9bf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK9JhWRh3pvFez7a+k3zuvbSuvV7QEnSl4CAiWRMLeZm4J90A==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsWyRsSkVtdmzvZggylT1S2WTbrLZvF91xd2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/Vov1M16zWHQsY7S4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVx7cw21oIFkhU3jq9jbmC8JNzFyMkhIWAi
	8X9bPzuELSZx4d56ti5GLg4hgaWMEn+f7WGFKdo/5zUbiC0ksIhRYtYDcQj7L6PEo9YiEJtN
	QFfiyfu5zCDNIgL9jBKzG8+BTWIWWMIosWfGKUaIscsYJeYd3g82llNAU2Lu5h9gtrBAuMSE
	q1/A7mARUJU4caQNzOYVsJSYvnMBE4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZIU5VkNhx
	9jUjiC0i4CTRtvQaO0SNuMSkBw/ZQY6QEGjkkHhx7jIzxDIBiW+TDwEN5QBKyEpsOgA1R1Li
	4IobLBOAnkWyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIGxffrf
	s74djDcPWB9iTAZaP5FZSjQ5H5ga8kriDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QDo3Fb8H62+hk2j2a2znuQyum+Xva6QtvWs1Nyiz/uO3jssbJR
	36Oc9Vosxx8fPfpfMdtQaHKxS9O1Lw5ThN29l026MH8x34eJH6xdsz0fCU/1jnLT8JKTPxCp
	ouvkd/3x/LdrL4TtNTDevlNMQfESR+ehHykbJ75aa7y8vl289Hz94eyn7e+dOJVYijMSDbWY
	i4oTARgSxPgDAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jAV2bOduDDfa1y1ssm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBbrZ7xmsehYxmhx89l2Jgduj5bmHjaP
	zUvqPfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxrUz
	21gLFkhW3Di+jrmB8ZJwFyMnh4SAicT+Oa/ZIGwxiQv31oPZQgKLGCVmPRCHsP8ySjxqLQKx
	2QR0JZ68n8vcxcjFISLQzygxu/EcG4jDLLCEUWLPjFOMII6QwDJGiXmH97OCtHAKaErM3fwD
	zBYWCJeYcPULO4jNIqAqceJIG5jNK2ApMX3nAiYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWve
	MkOcqiCx4+xrRhBbRMBJom3pNXaIGnGJSQ8esk9gFJqFZNQsJKNmIRk1C0nLAkaWVYyiqQXJ
	BcVJ6blGesWJucWleel6yfm5mxjBieOZ9A7GVQ0WhxgFOBiVeHgVjm0LFmJNLCuuzD3EKMHB
	rCTCWxGyPViINyWxsiq1KD++qDQntfgQoynQpxOZpUST84FJLa8k3tDYxNzU2NTSxMLEzFJJ
	nPdgq3WgkEB6YklqdmpqQWoRTB8TB6dUA2OTX/mlepO8227HvunVtDRtnmZ4gGWJTtbGusv6
	TddffNvDL3P5fo7Rs6Tzzn9KVdh3CgcfebNkoswFN/Y/ew9XHHU6JFWTJvPH8+2uWM2rffcr
	/qVGWHzw2fpr+QHNs0LiXFf+r1dL+GRZIp/+0C0sQO3C0423D8Z171PZfnPhxDNd2mFn49iV
	WIozEg21mIuKEwHE78NXMgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Monday, June 30, 2014 Tomasz Figa wrote:
> Hi Pankaj,
> 
> This looks much better now, but please see my comments inline.
> 
> On 25.06.2014 16:03, Pankaj Dubey wrote:
> > Under "arm/mach-exynos" many files are using PMU register offsets.
> > Since we have added support for accessing PMU base address via DT, now
> > we can remove PMU mapping from exynosX_iodesc. Let's convert all these
> > access using iomapped address.
> > This will help us in removing static mapping of PMU base address as
> > well as help in reducing dependency over machine header files.
> > Thus helping for migration of PMU implementation from machine to
> > driver folder which can be reused for ARM64 bsed SoC.
> 
> [snip]
> 
> > @@ -152,7 +142,7 @@ static void exynos_restart(enum reboot_mode mode,
> > const char *cmd)  {
> >  	struct device_node *np;
> >  	u32 val = 0x1;
> > -	void __iomem *addr = EXYNOS_SWRESET;
> > +	void __iomem *addr = NULL;
> 
> Instead of initializing this variable to NULL, pmu_base_addr +
> EXYNOS_SWRESET could be used instead.

OK.

> 
> >
> >  	if (of_machine_is_compatible("samsung,exynos5440")) {
> >  		u32 status;
> > @@ -165,9 +155,9 @@ static void exynos_restart(enum reboot_mode mode,
> const char *cmd)
> >  		val = __raw_readl(addr);
> >
> >  		val = (val & 0xffff0000) | (status & 0xffff);
> > -	}
> > -
> > -	__raw_writel(val, addr);
> > +		__raw_writel(val, addr);
> > +	} else
> > +		__raw_writel(val, pmu_base_addr + EXYNOS_SWRESET);
> 
> The above would allow this code to be left unchanged.
> 
> >  }
> >
> 
> [snip]
> 
> > diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> > index f127c0c..519aefe 100644
> > --- a/arch/arm/mach-exynos/pm.c
> > +++ b/arch/arm/mach-exynos/pm.c
> > @@ -37,6 +37,9 @@
> >  #include "regs-pmu.h"
> >  #include "regs-sys.h"
> >
> > +#define pmu_raw_writel(val, offset) \
> > +		__raw_writel(val, pmu_base_addr + offset)
> 
> Please make this static inline.
> 

OK.

> > +
> >  /**
> >   * struct exynos_wkup_irq - Exynos GIC to PMU IRQ mapping
> >   * @hwirq: Hardware IRQ signal of the GIC @@ -111,7 +114,7 @@ static
> > int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
> >   */
> >  void exynos_cpu_power_down(int cpu)
> >  {
> > -	__raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
> > +	pmu_raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
> >  }
> >
> >  /**
> > @@ -122,8 +125,8 @@ void exynos_cpu_power_down(int cpu)
> >   */
> >  void exynos_cpu_power_up(int cpu)
> >  {
> > -	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
> > -		     EXYNOS_ARM_CORE_CONFIGURATION(cpu));
> > +	pmu_raw_writel(S5P_CORE_LOCAL_PWR_EN,
> > +			EXYNOS_ARM_CORE_CONFIGURATION(cpu));
> >  }
> >
> >  /**
> > @@ -133,7 +136,7 @@ void exynos_cpu_power_up(int cpu)
> >   */
> >  int exynos_cpu_power_state(int cpu)
> >  {
> > -	return (__raw_readl(EXYNOS_ARM_CORE_STATUS(cpu)) &
> > +	return (__raw_readl(pmu_base_addr +
> EXYNOS_ARM_CORE_STATUS(cpu)) &
> >  			S5P_CORE_LOCAL_PWR_EN);
> 
> __raw_readl()s could be replaced with pmu_raw_readl()s too.
> 

OK, will update all these. 

> Best regards,
> Tomasz

Thanks,
Pankaj Dubey

