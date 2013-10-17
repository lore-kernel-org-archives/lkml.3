Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3JQXi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:38:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63444 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3JQXiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:38:25 -0400
X-AuditID: cbfee68f-b7fc96d000006ecb-54-526074f0a361
From: Kukjin Kim <kgene@kernel.org>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>, augulis.darius@gmail.com,
        "=?ISO-8859-1?Q?'J=FCrgen_Beisert'?=" <jbe@pengutronix.de>,
        oselas@community.pengutronix.de
References: <1380471121-9478-1-git-send-email-tomasz.figa@gmail.com>
 <1527511.ScaEHrLnaz@flatron>
In-reply-to: <1527511.ScaEHrLnaz@flatron>
Subject: RE: [PATCH] ARM: s3c64xx: mini6410: Correct card detect type for HSMMC1
Date: Fri, 18 Oct 2013 08:38:22 +0900
Message-id: <1e2a01cecb91$f790c700$e6b25500$@org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7Knkrdjt1XwEd2RDKCkQmnCM0cogA85kmg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zA90PJQlBBqt7hCz2vv3HaDFp3QEm
	i4NbFjJbbHp8jdXi8q45bBYzzu9jsrh9mddi05wjLBardv1hdOD0aGnuYfPo7ZnA6vF31Qtm
	j52z7rJ7bF5S79H/18Dj8ya5APYoLpuU1JzMstQifbsEroynF5YwFswSrNi9/yFjA2MLXxcj
	J4eEgInE/+NTWSFsMYkL99azgdhCAssYJV6cK4GpubdhMVMXIxdQfBGjxLGNxxkhiv4yShx/
	btnFyMHBJqAs0dikDxIWFtCSWLiliQXEFhHwkdg9bwobSC+zwGwmiSln37FA9CZLtPVDLOMU
	0JR4eOQ9K8gcYYEAiY/fU0BMFgFViZ6ztSAVvAKGEh/3HGCGsAUlfky+BzaFWUBHYn/rNDYI
	W15i85q3zCCtEgLqEo/+6kJcYCSxbM9OdogSEYl9L94xglwjITCVQ+Ln8W9gc1gEBCS+TT7E
	AtErK7EJYpWEgKTEwRU3WCYwSs5CsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UXGesWJucWl
	eel6yfm5mxghEd+/g/HuAetDjMlA6ycyS4km5wMTRl5JvKGxmZGFqYmpsZG5pRlpwkrivGot
	1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGBWbWkyfSC3jyd0fFPby9PVURY7vXsWXq4OW
	WRhvdqxN4RactdtwbcyB3azTJvVMKj2+9rfKyQMT2Z5FKRjNbGp8lhtSLvRG77nnxPvTf7eE
	xlU928lgU74u4+KftK0XPz7J8vyVOr0w9ujTW6/KmVt+X8vtevznaGJ6AJs/264tYp/3lTzr
	36XEUpyRaKjFXFScCAAfBFs1DgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jAd0PJQlBBve6eS32vv3HaDFp3QEm
	i4NbFjJbbHp8jdXi8q45bBYzzu9jsrh9mddi05wjLBardv1hdOD0aGnuYfPo7ZnA6vF31Qtm
	j52z7rJ7bF5S79H/18Dj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	dYwZTy8sYSyYJVixe/9DxgbGFr4uRk4OCQETiXsbFjNB2GISF+6tZ+ti5OIQEljEKHFs43FG
	kISQwF9GiePPLbsYOTjYBJQlGpv0QcLCAloSC7c0sYDYIgI+ErvnTQHrZRaYzSQx5ew7Foje
	ZIm2fpChnBycApoSD4+8ZwWZIywQIPHxewqIySKgKtFzthakglfAUOLjngPMELagxI/J98Cm
	MAvoSOxvncYGYctLbF7zlhmkVUJAXeLRX12IC4wklu3ZyQ5RIiKx78U7xgmMwrOQTJqFZNIs
	JJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4oTyT3sG4qsHiEKMAB6MSD++B
	b/FBQqyJZcWVuYcYJTiYlUR4W4UTgoR4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5js8kri
	DY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsXyNEsP64ybVBb/v
	XqsQNpR0d/Dkbbgdm/KAtX3D9RKd2H/KSz5vkCkRe1gX6rPx+9K7zYVcby2tWkuO7r665n6U
	wQ9RFjOGi0nH5hor7bSb1pD1iG2D4lefRU9EX4dvUQ08xVsx1+ju3Mw39o9m/eZ3nbz8aP6p
	F3KxLcsLu89d0FV9elI2U4mlOCPRUIu5qDgRAOtE5sxsAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Hi Kukjin,
> 
Hi,

> On Sunday 29 of September 2013 18:12:01 Tomasz Figa wrote:
> > According to board schematics, for HSMMC1 a GPIO line is used to detect
> > card presence, while currently it is being configured for internal card
> > detect line, which is multiplexed with card detect line of HSMMC0 and
> > thus breaking it.
> >
> > This patch adds proper sdhci platform data setting card detect type to
> > external GPIO and fixing operation of HSMMC0.
> >
> > Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> > ---
> >  arch/arm/mach-s3c64xx/mach-mini6410.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> 
> Would you mind taking this patch to your tree?
> 
Applied, thanks.
Kukjin

> Best regards,
> Tomasz
> 
> > diff --git a/arch/arm/mach-s3c64xx/mach-mini6410.c
> > b/arch/arm/mach-s3c64xx/mach-mini6410.c index 58d46a3..97ae470 100644
> > --- a/arch/arm/mach-s3c64xx/mach-mini6410.c
> > +++ b/arch/arm/mach-s3c64xx/mach-mini6410.c
> > @@ -36,7 +36,9 @@
> >  #include <plat/devs.h>
> >  #include <plat/fb.h>
> >  #include <linux/platform_data/mtd-nand-s3c2410.h>
> > +#include <linux/platform_data/mmc-sdhci-s3c.h>
> >  #include <plat/regs-serial.h>
> > +#include <plat/sdhci.h>
> >  #include <linux/platform_data/touchscreen-s3c2410.h>
> >
> >  #include <video/platform_lcd.h>
> > @@ -214,6 +216,13 @@ static struct platform_device mini6410_lcd_powerdev
> > = { .dev.platform_data	= &mini6410_lcd_power_data,
> >  };
> >
> > +static struct s3c_sdhci_platdata mini6410_hsmmc1_pdata = {
> > +	.max_width		= 4,
> > +	.cd_type		= S3C_SDHCI_CD_GPIO,
> > +	.ext_cd_gpio		= S3C64XX_GPN(10),
> > +	.ext_cd_gpio_invert	= true,
> > +};
> > +
> >  static struct platform_device *mini6410_devices[] __initdata = {
> >  	&mini6410_device_eth,
> >  	&s3c_device_hsmmc0,
> > @@ -321,6 +330,7 @@ static void __init mini6410_machine_init(void)
> >
> >  	s3c_nand_set_platdata(&mini6410_nand_info);
> >  	s3c_fb_set_platdata(&mini6410_lcd_pdata[features.lcd_index]);
> > +	s3c_sdhci1_set_platdata(&mini6410_hsmmc1_pdata);
> >  	s3c24xx_ts_set_platdata(NULL);
> >
> >  	/* configure nCS1 width to 16 bits */

