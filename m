Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaFQEVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 00:21:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14251 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbaFQEU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 00:20:59 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-9f-539fc2284412
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, arnd@arndb.de, "'Rob Herring'" <robh+dt@kernel.org>,
        "'Randy Dunlap'" <rdunlap@infradead.org>,
        "'Wolfram Sang'" <wsa@the-dreams.de>,
        "'Russell King'" <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-i2c@vger.kernel.org
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
 <1399706419-13976-2-git-send-email-pankaj.dubey@samsung.com>
 <53970994.8010400@samsung.com>
In-reply-to: <53970994.8010400@samsung.com>
Subject: RE: [PATCH v3 1/6] i2c: s3c2410: Handle i2c sys_cfg register in i2c
 driver
Date: Tue, 17 Jun 2014 09:51:39 +0530
Message-id: <000301cf89e3$a43d3550$ecb79ff0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFGFxwhMBc3rJ51QTN4z3RDiHZXkQKOC0AUAn3YGAcCOxQ92pxNXycQ
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42JZI2JSp6txaH6wwf9PphZ/Jx1jt5h/5Byr
	Re+Cq2wWmx5fY7VY2LaExaLj7xdGi8u75rBZzDi/j8ni9mVei7d3prNYtO49wm6xfsZrFouV
	J2YxO/B6tDT3sHn8/jWJ0WPzCi2PTas62Tw2L6n36NuyitHj5KknLB6fN8kFcERx2aSk5mSW
	pRbp2yVwZdw/KVRwS71i09xDLA2MT+S6GDk5JARMJL61zWGCsMUkLtxbz9bFyMUhJLCUUWLa
	hh8sMEXX7n9nh0gsYpTY/vUjlPOXUWJd11uwdjYBXYkn7+cygyREBPoZJV5u/cEKkmAWmMkk
	8eF+PETHHUaJ328nA83l4OAU0JZo6YkCqREWCJVY9+k42CAWAVWJf9t+s4HYvAKWErvu7IKy
	BSV+TL7HAjFTS2L9Toh6ZgF5ic1r3jJDnKogsePsa0aQ8SICbhLd00UhSsQlJj14CHa0hMBK
	DonPj9vYIHYJSHybfAjsHAkBWYlNB6DGSEocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSia
	WpBcUJyUXmSkV5yYW1yal66XnJ+7iRGYEk7/e9a3g/HmAetDjMlA6ycyS4km5wNTSl5JvKGx
	mZGFqYmpsZG5pRlpwkrivIseJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYBQMcpntYSi1
	Y7v5+1XPLzu+u/qkrqj/aGVBmEPhDbY5ZX8CnQTevp20v9Lh3mGfrAVrX3gLB2sKTRbjKlTS
	tsu8sf+p9c4TG67NfDaxX/ANp+w6zloOj4UzvjyqmlISKJHH153K9lVBfgrbqumRsw403ZiR
	euvH3+O34jdXL5FfdK+mvpBrraISS3FGoqEWc1FxIgCYV9DgHwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t9jAV2NQ/ODDToWaFv8nXSM3WL+kXOs
	Fr0LrrJZbHp8jdViYdsSFouOv18YLS7vmsNmMeP8PiaL25d5Ld7emc5i0br3CLvF+hmvWSxW
	npjF7MDr0dLcw+bx+9ckRo/NK7Q8Nq3qZPPYvKTeo2/LKkaPk6eesHh83iQXwBHVwGiTkZqY
	klqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SxkkJZYk4pUCgg
	sbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj/kmhglvqFZvmHmJpYHwi18XIySEhYCJx
	7f53dghbTOLCvfVsXYxcHEICixgltn/9yA7h/GWUWNf1lgmkik1AV+LJ+7nMIAkRgX5GiZdb
	f7CCJJgFZjJJfLgfD9Fxh1Hi99vJLF2MHBycAtoSLT1RIDXCAqES6z4dBxvEIqAq8W/bbzYQ
	m1fAUmLXnV1QtqDEj8n3WCBmakms3wlRzywgL7F5zVtmiFMVJHacfc0IMl5EwE2ie7ooRIm4
	xKQHD9knMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4ITz
	THoH46oGi0OMAhyMSjy8D2TnBwuxJpYVV+YeYpTgYFYS4eUyBwrxpiRWVqUW5ccXleakFh9i
	TAZ6dCKzlGhyPjAZ5pXEGxqbmJsam1qaWJiYWZImrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMH
	p1QDYy/L1SPKuSU9U9MYkn4FupStnPvo9r9P9prbGcQ+XFnka6IRMH31o9f8F3/9Kmla0aFj
	5t7Sc9BOZXbBUuv+gFJmH37ey5qPOWIbo/JsgquS7pb+eMmkKyD1W6Cz48jf4vAj4rN8/7XF
	L7Jg+v16hT3f1Kfbt9rPFl2996tXx6vHTQ/rlQ9NU2Ipzkg01GIuKk4EACs+ZAh8AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

> 
> Hi Pankaj,
> 
> On 10.05.2014 09:20, Pankaj Dubey wrote:
> > Let's handle i2c interrupt re-configuration in i2c driver. This will
> > help us in removing some soc specific checks from machine files.
> > Since only Exynos5250, and Exynos5420 need to do this, added syscon
> > based phandle to i2c device nodes of respective SoC DT files.
> > Also handle saving and restoring of SYS_I2C_CFG register during
> > suspend and resume of i2c driver. This will help in removing soc
> > specific check from mach-exynos/pm.c.
> >
> > CC: Rob Herring <robh+dt@kernel.org>
> > CC: Randy Dunlap <rdunlap@infradead.org>
> > CC: Wolfram Sang <wsa@the-dreams.de>
> > CC: Russell King <linux@arm.linux.org.uk>
> > CC: devicetree@vger.kernel.org
> > CC: linux-doc@vger.kernel.org
> > CC: linux-i2c@vger.kernel.org
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > ---
> >  .../devicetree/bindings/arm/samsung/sysreg.txt     |    1 +
> >  arch/arm/boot/dts/exynos5.dtsi                     |    5 +++
> >  arch/arm/boot/dts/exynos5250.dtsi                  |    4 +++
> >  arch/arm/boot/dts/exynos5420.dtsi                  |    4 +++
> 
> What about Exynos5410 and Exynos5800?

OK, I will check user manuals of these two SoCs and if required will update.

> 
> >  drivers/i2c/busses/i2c-s3c2410.c                   |   32
> ++++++++++++++++++++
> >  5 files changed, 46 insertions(+)
> 
> [snip]
> 
> > diff --git a/drivers/i2c/busses/i2c-s3c2410.c
> > b/drivers/i2c/busses/i2c-s3c2410.c
> > index ae44910..e707062 100644
> > --- a/drivers/i2c/busses/i2c-s3c2410.c
> > +++ b/drivers/i2c/busses/i2c-s3c2410.c
> > @@ -39,6 +39,8 @@
> >  #include <linux/of.h>
> >  #include <linux/of_gpio.h>
> >  #include <linux/pinctrl/consumer.h>
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/regmap.h>
> >
> >  #include <asm/irq.h>
> >
> > @@ -91,6 +93,9 @@
> >  /* Max time to wait for bus to become idle after a xfer (in us) */
> >  #define S3C2410_IDLE_TIMEOUT	5000
> >
> > +/* Exynos5 Sysreg offset */
> > +#define EXYNOS5_SYS_I2C_CFG	0x0234
> > +
> >  /* i2c controller state */
> >  enum s3c24xx_i2c_state {
> >  	STATE_IDLE,
> > @@ -127,6 +132,8 @@ struct s3c24xx_i2c {  #if
> > defined(CONFIG_ARM_S3C24XX_CPUFREQ)
> >  	struct notifier_block	freq_transition;
> >  #endif
> > +	struct regmap		*sysreg;
> > +	unsigned int		sys_i2s_cfg;
> 
> typo: s/i2s/i2c/

Oops, sorry I will correct this. 

> 
> >  };
> >
> >  static struct platform_device_id s3c24xx_driver_ids[] = { @@ -1075,6
> > +1082,8 @@ static void  s3c24xx_i2c_parse_dt(struct device_node *np,
> > struct s3c24xx_i2c *i2c)  {
> >  	struct s3c2410_platform_i2c *pdata = i2c->pdata;
> > +	u32 val = 0;
> > +	int id;
> >
> >  	if (!np)
> >  		return;
> > @@ -1084,6 +1093,23 @@ s3c24xx_i2c_parse_dt(struct device_node *np,
struct
> s3c24xx_i2c *i2c)
> >  	of_property_read_u32(np, "samsung,i2c-slave-addr",
&pdata->slave_addr);
> >  	of_property_read_u32(np, "samsung,i2c-max-bus-freq",
> >  				(u32 *)&pdata->frequency);
> > +	/*
> > +	 * Exynos5's legacy i2c controller and new high speed i2c
> > +	 * controller have muxed interrupt sources. By default the
> 
> What do you mean by "by default"? Is it a setting from the bootloader or
reset value?
> 

It's a reset value.

> Probably to ensure that the mux is set correctly, same thing should be
also added to
> hsi2c driver.
> 
> > +	 * interrupts for 4-channel HS-I2C controller are enabled.
> > +	 * If node for first four channels of legacy i2c controller
> > +	 * are available then re-configure the interrupts via the
> > +	 * system register.
> > +	 */
> > +	id = of_alias_get_id(np, "i2c");
> > +	i2c->sysreg = syscon_regmap_lookup_by_phandle(np,
> > +			"samsung,syscon-phandle");
> > +	if (IS_ERR(i2c->sysreg)) {
> > +		/* As this is not compulsory do not return error */
> > +		pr_info("i2c-%d skipping re-configuration of interrutps\n",
id);
> > +		return;
> > +	}
> > +	regmap_update_bits(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, BIT(id), val);
> 
> As Wolfram pointed, val can be replaced with immediate 0 here.

OK, I will take care as per suggestion.

> 
> >  }
> >  #else
> >  static void
> > @@ -1268,6 +1294,9 @@ static int s3c24xx_i2c_suspend_noirq(struct
> > device *dev)
> >
> >  	i2c->suspended = 1;
> >
> > +	if (!IS_ERR(i2c->sysreg))
> > +		regmap_read(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, &i2c-
> >sys_i2s_cfg);
> > +
> >  	return 0;
> >  }
> >
> > @@ -1276,6 +1305,9 @@ static int s3c24xx_i2c_resume(struct device *dev)
> >  	struct platform_device *pdev = to_platform_device(dev);
> >  	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
> >
> > +	if (!IS_ERR(i2c->sysreg))
> > +		regmap_write(i2c->sysreg, i2c->sys_i2s_cfg,
> EXYNOS5_SYS_I2C_CFG);
> 
> According to include/linux/regmap.h:
> 
> int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
> 
> So in your code reg is swapped with val.

Yes. I will correct this.

> 
> Best regards,
> Tomasz

