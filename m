Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaEICOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:14:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28054 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbaEICOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:14:51 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-47-536c3a191c4b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: t.figa@samsung.com, linux@arm.linux.org.uk, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, chanho61.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1398735462-1938-1-git-send-email-cw00.choi@samsung.com>
 <5369B88E.9030901@samsung.com>
In-reply-to: <5369B88E.9030901@samsung.com>
Subject: RE: [PATCHv5] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
Date: Fri, 09 May 2014 11:14:49 +0900
Message-id: <034d01cf6b2c$748bdd50$5da397f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJS/gskkkhjsryiJuzOhwjbAmPAvgJ6JnZRmhx3biA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zQ11Jq5xggw2z9Swu79e2uP7lOavF
	5w8t7BaT7k9gsTjb9IbdYtPja6wWl3fNYbOYcX4fk8Xty7wWMya/ZLNYP+M1i8XenZMZHXg8
	Wpp72Dw2L6n36NuyitHj8ya5AJYoLpuU1JzMstQifbsEroyHa78yFnzgr1jV+Ii1gXEzTxcj
	J4eEgInE+jsbWCBsMYkL99azdTFycQgJLGOU+LR5MnMXIwdY0etlYRDxRYwSa//+ZYdw/jJK
	7Hx9lBWkm01AQ+Lw+2fsILaIgJbExM6ZTCBFzAIbmCQef3/JDJIQEkiVOLFyP9hUTgFtib/z
	K0HCwgI+Elf3vWIEsVkEVCU+NOwGK+cVsJRYe2gXG4QtKPFj8j2wS5mB5m/e1sQKYctLbF7z
	lhniAwWJHWdfM0LcYCVxouELVL2IxL4X7xhB7pEQ6OWQmPD0OQvEMgGJb5MPsUB8KSux6QDU
	HEmJgytusExglJiFZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzFC
	Irx/B+PdA9aHGJOB1k9klhJNzgcmiLySeENjMyMLUxNTYyNzSzPShJXEee8/TAoSEkhPLEnN
	Tk0tSC2KLyrNSS0+xMjEwSnVwOjJ39yr+luWX/zBy3MMLCUT9U2sfkwS3dq/6M6jbb5HmDbt
	WGod28r7eP0r7eW2FayCvgdU1z8Wk59UvEictc9rS+kxXq/o0JwAhQje+Az1k7nv3ght77uy
	ZMfL25eYg94JPXv9ZqZIca7Gy8rGxfdcWC2tt+RZLFR7HC8koLXw4yzPL28PHlZiKc5INNRi
	LipOBADbQYQCBgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jAV1Jq5xggyu7NC0u79e2uP7lOavF
	5w8t7BaT7k9gsTjb9IbdYtPja6wWl3fNYbOYcX4fk8Xty7wWMya/ZLNYP+M1i8XenZMZHXg8
	Wpp72Dw2L6n36NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	dYwZD9d+ZSz4wF+xqvERawPjZp4uRg4OCQETidfLwroYOYFMMYkL99azdTFycQgJLGKUWPv3
	LzuE85dRYufro6wgVWwCGhKH3z9jB7FFBLQkJnbOZAIpYhbYwCTx+PtLZpCEkECqxImV+5lB
	NnAKaEv8nV8JEhYW8JG4uu8VI4jNIqAq8aFhN1g5r4ClxNpDu9ggbEGJH5PvsYDYzEDzN29r
	YoWw5SU2r3nLDHGpgsSOs68ZIW6wkjjR8AWqXkRi34t3jBMYhWYhGTULyahZSEbNQtKygJFl
	FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw+ngmtYNxZYPFIUYBDkYlHt4XU7KDhVgTy4or
	cw8xSnAwK4nw3tHPCRbiTUmsrEotyo8vKs1JLT7EmAz06URmKdHkfGBqyyuJNzQ2MTOyNDKz
	MDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxhM+1QvFi7ZFXinL+WsqFtz4YFGF
	xQ03nwUrz7RqbciSufMvcr5/F/caky0XlUIuKZy7da/rnmXz+usfTi+d375VSWlX/zLv8yo2
	8/iFZ7MfW+4ysz5uwzlL1vZek6YzeVFO0oWrTyTcntYrLPNTOPtbzhbRmS9mbFFZLHXcz1ju
	7r9Lr55XiSmxFGckGmoxFxUnAgB92id9YwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanwoo Choi wrote:
> 
> Dear Kukjin,
> 
> Could you please pick this patch?
> 
I've applied.

Thanks,
Kukjin

> Best Regards,
> Chanwoo Choi
> 
> On 04/29/2014 10:37 AM, Chanwoo Choi wrote:
> > From: Kyungmin Park <kyungmin.park@samsung.com>
> >
> > This patch fix the offset of CPU boot address and change parameter of
> smc call
> > of SMC_CMD_CPU1BOOT command for Exynos4212.
> >
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > ---
> > Changes from v4:
> > - Post only this patch separated from following patchset[1]
> > [1] https://lkml.org/lkml/2014/4/24/873
> >
> >  arch/arm/mach-exynos/firmware.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-
> exynos/firmware.c
> > index 932129e..aa01c42 100644
> > --- a/arch/arm/mach-exynos/firmware.c
> > +++ b/arch/arm/mach-exynos/firmware.c
> > @@ -18,6 +18,8 @@
> >
> >  #include <mach/map.h>
> >
> > +#include <plat/cpu.h>
> > +
> >  #include "smc.h"
> >
> >  static int exynos_do_idle(void)
> > @@ -28,13 +30,24 @@ static int exynos_do_idle(void)
> >
> >  static int exynos_cpu_boot(int cpu)
> >  {
> > +	/*
> > +	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
> > +	 * But, Exynos4212 has only one secondary CPU so second parameter
> > +	 * isn't used for informing secure firmware about CPU id.
> > +	 */
> > +	if (soc_is_exynos4212())
> > +		cpu = 0;
> > +
> >  	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
> >  	return 0;
> >  }
> >
> >  static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
> >  {
> > -	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c + 4*cpu;
> > +	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
> > +
> > +	if (!soc_is_exynos4212())
> > +		boot_reg += 4*cpu;
> >
> >  	__raw_writel(boot_addr, boot_reg);
> >  	return 0;
> >

