Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbaBFHYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 02:24:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32761 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaBFHYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 02:24:04 -0500
X-AuditID: cbfee690-b7f266d00000287c-f7-52f3388567fe
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Thierry Reding'" <thierry.reding@gmail.com>
Cc: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Eric Miao'" <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org>
 <000401cf222f$43263b20$c972b160$%han@samsung.com>
 <CACRpkdbB8LFM0Vu8VRo4niqxwxUdS-c5gmmWaxbUTbnLCLZbMA@mail.gmail.com>
 <000101cf2307$97a3c770$c6eb5650$%han@samsung.com>
In-reply-to: <000101cf2307$97a3c770$c6eb5650$%han@samsung.com>
Subject: Re: [PATCH] backlight: add PWM dependencies
Date: Thu, 06 Feb 2014 16:23:48 +0900
Message-id: <000001cf230c$60ec1ca0$22c455e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8iUE/iqGSybP6uTbyxaFS67OfvHwAtkufwAADCzSA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t8zY91Wi89BBvuvcFv8nXSM3WJH23E2
	i8sLL7FaTPmznMli0+NrrBaXd81hs7h7dxWjxe3LvBY/d81jceD0aGnuYfP4/WsSo8fOWXfZ
	Pe5c28PmsXlJvUffllWMHp83yQWwR3HZpKTmZJalFunbJXBlrDu1iLFgmmrFps2mDYw/ZLsY
	OTkkBEwkZq3tY4KwxSQu3FvP1sXIxSEksIxR4s6pc4wwRR8nLmOFSCxilHj37RULSEJI4Bej
	xIfTmSA2m4CaxJcvh9lBbBGBWIktk/8zgjQwC7QxSby9vIARovsbo8T6TzOZQao4BewkVk3t
	B9stDLTi7uF/YOtYBFQlLh1eCzaJV8BW4vTVpWwQtqDEj8n3wDYzC2hJrN95nAnClpfYvOYt
	0EwOoFPVJR791YU4wkri6fKz7BAlIhL7XrwDu0FCoJdD4t/DHcwQuwQkvk0+xALRKyux6QAz
	xMeSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525i
	hMT4hB2M9w5YH2JMBlo/kVlKNDkfmCLySuINjc2MLExNTI2NzC3NSBNWEudVe5QUJCSQnliS
	mp2aWpBaFF9UmpNafIiRiYNTqoGRY+/sH/Kax+wMP8q90ixYr52hrO93tnz34RXds9+tDz/Q
	uWOOsa8DwwdRy+o5SQLsz76Zhs5JEK4vUn73X2r2kgsXtcx8Hj5l6Fq4Zs8cyVUZUpUl8Vv6
	CzwkSuNslikfe7Ny4bHUb6/Z13it9HwTrjjLf6fMy4smP9YFbjIMnMumZe3wrSRDiaU4I9FQ
	i7moOBEADFuARAcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jAd1Wi89BBpu3sln8nXSM3WJH23E2
	i8sLL7FaTPmznMli0+NrrBaXd81hs7h7dxWjxe3LvBY/d81jceD0aGnuYfP4/WsSo8fOWXfZ
	Pe5c28PmsXlJvUffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzFh3ahFjwTTVik2bTRsYf8h2MXJySAiYSHycuIwVwhaTuHBvPVsXIxeHkMAiRol3316x
	gCSEBH4xSnw4nQliswmoSXz5cpgdxBYRiJXYMvk/I0gDs0Abk8TbywsYIbq/MUqs/zSTGaSK
	U8BOYtXUfiYQWxho3d3D/xhBbBYBVYlLh9eCTeIVsJU4fXUpG4QtKPFj8j2wzcwCWhLrdx5n
	grDlJTaveQs0kwPoVHWJR391IY6wkni6/Cw7RImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEj
	yypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4ATyTHoH46oGi0OMAhyMSjy8G9Z/ChJiTSwr
	rsw9xCjBwawkwrvV/HOQEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJJucDk1teSbyhsYmZkaWR
	mYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTAWr/wTKNFfkx/IcY41oO38jgl6
	+u6FjBY7MvgW1l51F9nu3rHi8HGz6juhHomff31aPzP9hepr/Uee9p8O1K2LFF06U+F1OqPX
	8S1u+9n9Noe8XSqX9sVhRaLlm5ec5q18x9QOP7t+eLvQs7Qnvi9eZpjvFf31bIlF3OsLzzi1
	NT58kil+eOG+EktxRqKhFnNRcSIACg1+bGQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 06, 2014 3:50 PM, Jingoo Han wrote:
> On Wednesday, February 05, 2014 5:58 PM, Linus Walleij wrote:
> > On Wed, Feb 5, 2014 at 6:01 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > > On Tuesday, February 04, 2014 9:57 PM, Linus Walleij wrote:
> > >>
> > >> In some compilations the LM3630A and LP855X backlight drivers
> > >> fail like this:
> > >>
> > >> drivers/built-in.o: In function `lm3630a_pwm_ctrl':
> > >> drivers/video/backlight/lm3630a_bl.c:168: undefined reference to `pwm_config'
> > >> drivers/video/backlight/lm3630a_bl.c:172: undefined reference to `pwm_disable'
> > >> drivers/video/backlight/lm3630a_bl.c:170: undefined reference to `pwm_enable'
> > >> drivers/built-in.o: In function `lp855x_pwm_ctrl':
> > >> drivers/video/backlight/lp855x_bl.c:249: undefined reference to `pwm_config'
> > >> drivers/video/backlight/lp855x_bl.c:253: undefined reference to `pwm_disable'
> > >> drivers/video/backlight/lp855x_bl.c:251: undefined reference to `pwm_enable'
> > >>
> > >> This is because both drivers depend on the PWM framework, so
> > >> add this dependency to their Kconfig entries.
> > >
> > > However, even though, when CONFIG_PWM is not enabled, the problem
> > > should not happen. pwm_config(),pwm_disable(), and pwm_enable()
> > > are already defined for CONFIG_PWM=n case as below.
> >
> > So you may think but it does happen :-)
> >
> > I reproduced this with the defconfig for ARM pxa255-idp and enabling
> > all boards for that platform, then enabling all available backlight drivers
> > as compiled-in objects (y).
> 
> However, I cannot reproduce it with mainline kernel 3.14-rc1.
> 
> 1. make pxa255-idp_defconfig
> 2. Enabling all boards
>    (System Type -> Intel PXA2xx/PXA3xx Implementations -> ...)
> 3. Enabling all available backlight drivers as compiled-in objects (y)
> 
> In this case, the LM3630A and LP855X backlight drivers are compiled
> properly as below:
> 
>   drivers/video/backlight/lm3630a_bl.o
>   drivers/video/backlight/lp855x_bl.o
> 
> Would you check it with mainline kernel 3.14-rc1?
> If the errors happen, please attach the .config file.

(+cc Arnd Bergmann)

Oh, sorry. There was my mistake.
I tested this with linux-next tree.

With linux 3.14-rc1, it makes the problem as below.

drivers/built-in.o: In function `lm3630a_pwm_ctrl':
drivers/video/backlight/lm3630a_bl.c:168: undefined reference to `pwm_config'
drivers/video/backlight/lm3630a_bl.c:172: undefined reference to `pwm_disable'
drivers/video/backlight/lm3630a_bl.c:170: undefined reference to `pwm_enable'
drivers/built-in.o: In function `lp855x_pwm_ctrl':
drivers/video/backlight/lp855x_bl.c:249: undefined reference to `pwm_config'
drivers/video/backlight/lp855x_bl.c:253: undefined reference to `pwm_disable'
drivers/video/backlight/lp855x_bl.c:251: undefined reference to `pwm_enable'

> 
> >
> > > ./include/linux/pwm.h
> > > #if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
> > >         .....
> > > #else
> >
> > Hm PXA that I am using defines CONFIG_HAVE_PWM, but doesn't
> > provide the required signatures (pwm_config/pwm_disable/pwm_enable).
> >
> > One of two things is wrong:
> >
> > - Either the PXA platform is breaking the CONFIG_HAVE_PWM
> >   contract by not providing pwm_config/pwm_disable/pwm_enable
> >   functions. Then HAVE_PWM should be removed from the PXA
> >   Kconfig selects.
> >
> > Or:
> >
> > - There is no such contract that these functions must exist if
> >   CONFIG_HAVE_PWM is defined, and the
> >   #if IS_ENABLED(CONFIG_HAVE_PWM)
> >   should be removed from <linux/pwm.h>
> >
> > Does anyone know which one it is?
> >
> > PWM subsystem maintainer? :-)

Thierry Reding,
Would you confirm this?

In the case of "CONFIG_HAVE_PWM=y && CONFIG_PWM=n", it makes
the problem.

The HAVE_PWM symbol is only for legacy platforms that provide
the PWM API without using the generic framework. PXA looks to
use the generic PWM framework. Then, how about removing
"select HAVE_PWM" from PXA as below?

--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -7,7 +7,6 @@ comment "Intel/Marvell Dev Platforms (sorted by hardware release time)"
 config MACH_PXA3XX_DT
        bool "Support PXA3xx platforms from device tree"
        select CPU_PXA300
-       select HAVE_PWM
        select POWER_SUPPLY
        select PXA3xx
        select USE_OF
@@ -23,12 +22,10 @@ config ARCH_LUBBOCK

 config MACH_MAINSTONE
        bool "Intel HCDDBBVA0 Development Platform (aka Mainstone)"
-       select HAVE_PWM
        select PXA27x

 config MACH_ZYLONITE
        bool
-       select HAVE_PWM
        select PXA3xx
.....


Best regards,
Jingoo Han

