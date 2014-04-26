Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaDZKtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 06:49:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46234 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaDZKtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 06:49:16 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-98-535b8f2a85a8
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>, t.figa@samsung.com
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, chanho61.park@samsung.com,
        sajjan.linux@gmail.com, tushar.behera@linaro.org,
        sachin.kamat@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
 <1398388572-30239-3-git-send-email-cw00.choi@samsung.com>
 <535B00E5.4060903@gmail.com>
In-reply-to: <535B00E5.4060903@gmail.com>
Subject: RE: [PATCHv4 2/7] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
Date: Sat, 26 Apr 2014 19:49:13 +0900
Message-id: <0b3601cf613d$29ae93c0$7d0bbb40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGN6wm/InyHbfPXHkpuqDnpDebpYwKz9FKFALUJftKbi1s+IA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t8zI12t/uhgg69PWC3+TjrGbjFp3QEm
	i8v7tS2uf3nOajH/yDlWi88fWoDi9yewWJxtesNusenxNVaLy7vmsFnMOL+PyeL2ZV6Lv3f+
	sVmcuv6ZzeLkn15GiyeHP7JazJj8ks1i/YzXLBbHZixhtFi16w+jRfvfvWwWe3dOZnQQ81gz
	bw2jR0tzD5vH71+TGD3+rnrB7LFz1l12jzvX9rB5bF5S73HlRBOrR9+WVYwenzfJBXBFcdmk
	pOZklqUW6dslcGVM6N3PWnCSv+LLvxeMDYytPF2MnBwSAiYSSxreMkHYYhIX7q1n62Lk4hAS
	WMYo8azvEEsXIwdY0ZfrrBDx6YwSOw7sh3L+Mkqs/vuQHaSbTUBD4vD7Z2C2iEC6RO/hVWCT
	mAXeMEu0/p3KDtGxgFGibeNPZpAqTgFNiUnr74DtFhYIkPjxcDIjiM0ioCoxf+tKMJtXwFKi
	+XArE4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZIX5QkNhx9jUjyNkiAk4SO+aaQJSISOx7
	8Y4RoqSZU+LMIymIVQIS3ybDfCkrsekA1BRJiYMrbrBMYJSYhWTxLCSLZyFZPAvJhgWMLKsY
	RVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxQhLQxB2M9w9YH2JMBlo/kVlKNDkfmMDySuINjc2M
	LExNTI2NzC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGRJS9/3u1ErtOn
	z3rs+TqxIEq50X2VzqQZPJNnH3Ho/8lx+fyeRulMFvW9348qqul5VM7fbKl9clKlud/tNxIM
	3q2ugUvkD0pLaTxMP/3UqE7wNb8xf1ShSP76r44hl0IOqfevX9rvL7AubALnCf759xZVGcX5
	dL9ann3VR3H6a7816sfn7shRYinOSDTUYi4qTgQAaecGJlYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsVy+t9jQV3N/uhgg209NhZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLUDx+xNYLM42vWG32PT4GqvF5V1z2CxmnN/HZHH7Mq/F3zv/
	2CxOXf/MZnHyTy+jxZPDH1ktZkx+yWaxfsZrFotjM5YwWqza9YfRov3vXjaLvTsnMzqIeayZ
	t4bRo6W5h83j969JjB5/V71g9tg56y67x51re9g8Ni+p97hyoonVo2/LKkaPz5vkAriiGhht
	MlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AeVVIoS8wp
	BQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmTOjdz1pwkr/iy78XjA2MrTxdjBwc
	EgImEl+us3YxcgKZYhIX7q1n62Lk4hASmM4osePAflYI5y+jxOq/D9lBqtgENCQOv38GZosI
	pEv0Hl4F1sEs8IZZovXvVHaIjgWMEm0bfzKDVHEKaEpMWn+HCcQWFgiQ+PFwMiOIzSKgKjF/
	60owm1fAUqL5cCsThC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5khblWQ2HH2NSPICyICThI7
	5ppAlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P
	3cQITnDPpHYwrmywOMQowMGoxMO7IycqWIg1say4MvcQowQHs5II76KU6GAh3pTEyqrUovz4
	otKc1OJDjMlAj05klhJNzgcm37ySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YW
	pBbBbGHi4JRqYKx426Hq89pQZIljygH9EI7T1R+r3LLY1P9V9l6PVHGpqax4JrqzI0bgX/li
	70W3X12L+7HtYumjbzKKjoe9VD7P04h2q23bPetjQ6OS8Sb/J36FPLumcl7dcC7yywO5e/WT
	X5zK+ly38Ma3C2sjX8ld+72Yp9+nPbPj4NUecbZ34TN3bCk+cUyJpTgj0VCLuag4EQAGQapH
	tAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Hi,
> 
Hi,

> On 25.04.2014 03:16, Chanwoo Choi wrote:
> > From: Kyungmin Park <kyungmin.park@samsung.com>
> >
> > This patch fix the offset of CPU boot address and change parameter of
> smc call
> > of SMC_CMD_CPU1BOOT command for Exynos4212.
> >
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> > ---
> >   arch/arm/mach-exynos/firmware.c | 15 ++++++++++++++-
> >   1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-
> exynos/firmware.c
> > index 932129e..aa01c42 100644
> > --- a/arch/arm/mach-exynos/firmware.c
> > +++ b/arch/arm/mach-exynos/firmware.c
> > @@ -18,6 +18,8 @@
> >
> >   #include <mach/map.h>
> >
> > +#include <plat/cpu.h>
> > +
> >   #include "smc.h"
> >
> >   static int exynos_do_idle(void)
> > @@ -28,13 +30,24 @@ static int exynos_do_idle(void)
> >
> >   static int exynos_cpu_boot(int cpu)
> >   {
> > +	/*
> > +	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
> > +	 * But, Exynos4212 has only one secondary CPU so second parameter
> > +	 * isn't used for informing secure firmware about CPU id.
> > +	 */
> > +	if (soc_is_exynos4212())
> > +		cpu = 0;
> > +
> >   	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
> >   	return 0;
> >   }
> >
> >   static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
> >   {
> > -	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c + 4*cpu;
> > +	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
> > +
> > +	if (!soc_is_exynos4212())
> > +		boot_reg += 4*cpu;
> >
> >   	__raw_writel(boot_addr, boot_reg);
> >   	return 0;
> >
> 
> This patch should be applied independently of Exynos3250 support.
> Kukjin, what do you think?
> 
Yes, this should be separated. I will pick this into fixes.

> Anyway,
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 
Thanks,
Kukjin

