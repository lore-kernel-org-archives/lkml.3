Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaHUF2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:28:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12131 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaHUF2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:28:20 -0400
X-AuditID: cbfee690-b7f526d000003627-f5-53f5836ccc98
Date: Thu, 21 Aug 2014 05:27:50 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 2/2] extcon: sm5502: EXTCON_SM5502 should depend on I2C
To: =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140821052404959@myungjoo.ham
Msgkey: 20140821052404959@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140821052404959@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <2048653519.580921408598869113.JavaMail.weblogic@epmlwas01c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSqFvY/DXYYOcLcYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWx6P5N1oIuqYqGlc2MDYwbJLsYOTmEBNQlFi05yQZiSwiYSDx9
	c5EVwhaTuHBvPVCcC6hmKaPE7rX9zF2MHGBF34/lQsTnMEosvXqfEaSBRUBV4uPJiWA1bAJ6
	EjM/J4OYwgL+EjP+SYNUiAjkSLxceJgZpJVZYCKTxJ3ze9khblCSWLPvFQuIzSsgKHFy5hMW
	iBtUJQ7d2MAKEVeTuNr1Eeo2CYlZ0y9A2bwSM9qfQtXLSUz7uoYZwpaWOD9rAyPML4u/P4aK
	80scu72DCeIVXokn94Nhxuze/AUaDAISU88chGrVkvg74xrUKj6JNQvfssCM2XVqOTNM7/0t
	c5lAbGYBRYkp3Q/ZIWwtiS8/9rGhe4tXwEPi9+7djBMYlWchSc1C0j4LSTuymgWMLKsYRVML
	kguKk9KLTPSKE3OLS/PS9ZLzczcxApPC6X/PJuxgvHfA+hBjMjBGJjJLiSbnA5NKXkm8obGZ
	kYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwNkx4223HF3b+
	V0norJ1rdh34sfPN5h0afJV3LescRT9aXOxs8LaJK39wmr/fouAc67/FatZeTh+31ib/EnHQ
	VZ0YnKc4afk2m5od2x83LWD99ChMXP1jYMHqFJ6iHyZVv5wPGv09+aX1/vW3n6xWyEuIvjBv
	SL+WK1Cle3PP8inzzX5vmnVKS4mlOCPRUIu5qDgRAO1nOCAgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/tft2w5q/BBm8ua1tc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIxF
	92+yFnRJVTSsbGZsYNwg2cXIySEkoC6xaMlJti5GDg4JAROJ78dyQcISAmISF+6tBwpzAZXM
	YZRYevU+I0iCRUBV4uPJicwg9WwCehIzPyeDmMIC/hIz/kmDVIgI5Ei8XHiYGaSVWWAik8Sd
	83vZIVYpSazZ94oFxOYVEJQ4OfMJC8QuVYlDNzawQsTVJK52fWSFiEtIzJp+AcrmlZjR/hSq
	Xk5i2tc1zBC2tMT5WRsYYW5e/P0xVJxf4tjtHUwQb/FKPLkfDDNm9+YvbBC2gMTUMwehWrUk
	/s64BrWKT2LNwrcsMGN2nVrODNN7f8tcJhCbWUBRYkr3Q3YIW0viy499bOje4hXwkPi9ezfj
	BEa5WUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9ApjveLE3OLSvHS95PzcTYzg1PRs8Q7G/+et
	DzEKcDAq8fDeWPQlWIg1say4MvcQowQHs5IIr+svoBBvSmJlVWpRfnxRaU5q8SHGZGD8TWSW
	Ek3OB6bNvJJ4Q2NjEzMTU0sTCwNTc9KElcR5428lBQkJpCeWpGanphakFsFsYeLglGpgLBLs
	qVFufWD+T5jPMnd7zzKG9E8rpZKErRl1NtzYdd77wZyZ3+W//ecpW7ewWSJl7iftTe0cBUnv
	ihxrDDnuvdon8S/r1jk7U/nzi7i6Vkx7vjtLN8qnZsVtTjmbX6ce8SozHoxefbWjzKxJlCWa
	J+Gr+MoMMZXDlTMS705d4phyd8Z2ri8HlFiKMxINtZiLihMBFQwUkJEDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7L5Sgrb003558

> Hi Geert
> 
> Thanks for your report. I already sent a patch[1] to fix this build break
> and I'll send pull request to includec this patch in 3.17-rc2.
> 
> [1] https://lkml.org/lkml/2014/8/13/761
> 
> Best Regards,
> Chanwoo Choi

I do not object to this patch or your patch[1].

However, wouldn't it be better to add depends on I2C at REGMAP_I2C?
When you use REGMAP_I2C, you assume that I2C is already there, don't you?


Cheers,
MyungJoo

> 
> 
> On 08/17/2014 07:08 PM, Geert Uytterhoeven wrote:
> > EXTCON_SM5502 selects REGMAP_I2C, but if I2C=n:
> > 
> > drivers/base/regmap/regmap-i2c.c: In function °Æregmap_smbus_byte_reg_read°Ø:
> > drivers/base/regmap/regmap-i2c.c:28: error: implicit declaration of function °Æi2c_smbus_read_byte_data°Ø
> > drivers/base/regmap/regmap-i2c.c: In function °Æregmap_smbus_byte_reg_write°Ø:
> > drivers/base/regmap/regmap-i2c.c:46: error: implicit declaration of function °Æi2c_smbus_write_byte_data°Ø
> > drivers/base/regmap/regmap-i2c.c: In function °Æregmap_smbus_word_reg_read°Ø:
> > drivers/base/regmap/regmap-i2c.c:64: error: implicit declaration of function °Æi2c_smbus_read_word_data°Ø
> > drivers/base/regmap/regmap-i2c.c: In function °Æregmap_smbus_word_reg_write°Ø:
> > drivers/base/regmap/regmap-i2c.c:82: error: implicit declaration of function °Æi2c_smbus_write_word_data°Ø
> > drivers/base/regmap/regmap-i2c.c: In function °Æregmap_i2c_write°Ø:
> > drivers/base/regmap/regmap-i2c.c:96: error: implicit declaration of function °Æi2c_master_send°Ø
> > drivers/base/regmap/regmap-i2c.c: In function °Æregmap_i2c_gather_write°Ø:
> > drivers/base/regmap/regmap-i2c.c:117: error: implicit declaration of function °Æi2c_check_functionality°Ø
> > drivers/base/regmap/regmap-i2c.c:130: error: implicit declaration of function °Æi2c_transfer°Ø
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >  drivers/extcon/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
> > index 6f2f4727de2c..764f3a113e0a 100644
> > --- a/drivers/extcon/Kconfig
> > +++ b/drivers/extcon/Kconfig
> > @@ -72,6 +72,7 @@ config EXTCON_PALMAS
> >  
> >  config EXTCON_SM5502
> >  	tristate "SM5502 EXTCON support"
> > +	depends on I2C
> >  	select IRQ_DOMAIN
> >  	select REGMAP_I2C
> >  	select REGMAP_IRQ
> > 
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
