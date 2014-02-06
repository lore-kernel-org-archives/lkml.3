Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbaBFJAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 04:00:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54368 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbaBFJAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 04:00:42 -0500
X-AuditID: cbfee690-b7f266d00000287c-57-52f34f383171
From: Jingoo Han <jg1.han@samsung.com>
To: "'Eric Miao'" <eric.y.miao@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] ARM: pxa: don't select HAVE_PWM
Date: Thu, 06 Feb 2014 18:00:39 +0900
Message-id: <000e01cf2319$e8837e80$b98a7b80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jGehl9iGslFEuTge0hUmQ1iW6nA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zA10L/89BBtNu8lv8nXSM3WJH23E2
	i8sLL7FaTPmznMli0+NrrBaXd81hs7h7dxWjxe3LvBY/d81jceD0aGnuYfP4/WsSo8fOWXfZ
	Pe5c28PmsXlJvUffllWMHp83yQWwR3HZpKTmZJalFunbJXBlXL58halgm3zFz2unWRoYt0t2
	MXJwSAiYSGxsMOti5AQyxSQu3FvPBmILCSxjlPg8qxSm5NBDtS5GLqDwdEaJ81+eMEE4vxgl
	JndvZQVpYBNQk/jy5TA7iC0ioC5xc9sEdpAiZoF9TBINa1eCTRUWMJB4M2MmE4jNIqAqMft6
	N1icV8BW4sO1mywQtqDEj8n3wGxmAS2J9TuPM0HY8hKb17xlhrhIXeLRX12IXXoSn6c9YIMo
	EZHY9+IdI8heCYGP7BL7V95lhtglIPFt8iEWiF5ZiU0HmCEelpQ4uOIGywRGsVlINs9CsnkW
	ks2zkKxYwMiyilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMkXifsYLx3wPoQYzLQ+onMUqLJ
	+cB4zyuJNzQ2M7IwNTE1NjK3NCNNWEmcV+1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	xujHkWUZE70ffLK+/qtGRixA67wnR196JF+07uKETeU5dfnfz32Xn35Y6ptQntS3tMvMUs4J
	xrPD/gbnvT2remL+3dzESabsve8/hHiHMNxW6vRx3J1ckvuh75KBndyJTPUXE2MULRz5wsJW
	3I9bsYpd+6G080Hh/7LmYWtULk5X1Uo6Z3BSiaU4I9FQi7moOBEAvUCno+0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQV0L/89BBrfucFn8nXSM3WJH23E2
	i8sLL7FaTPmznMli0+NrrBaXd81hs7h7dxWjxe3LvBY/d81jceD0aGnuYfP4/WsSo8fOWXfZ
	Pe5c28PmsXlJvUffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzLh8+QpTwTb5ip/XTrM0MG6X7GLk4JAQMJE49FCti5ETyBSTuHBvPVsXIxeHkMB0Ronz
	X54wQTi/GCUmd29lBaliE1CT+PLlMDuILSKgLnFz2wR2kCJmgX1MEg1rV7KBJIQFDCTezJjJ
	BGKzCKhKzL7eDRbnFbCV+HDtJguELSjxY/I9MJtZQEti/c7jTBC2vMTmNW+ZIa5Tl3j0Vxdi
	l57E52kP2CBKRCT2vXjHOIFRYBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfm
	pesl5+duYgQnhGfSOxhXNVgcYhTgYFTi4d2w/lOQEGtiWXFl7iFGCQ5mJRFeM+/PQUK8KYmV
	ValF+fFFpTmpxYcYk4EencgsJZqcD0xWeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8s
	Sc1OTS1ILYLZwsTBKdXA6Nf864XiqmOJ7D0/KmeFbJW109Ncpfi4TUDrpnP9kQfGk7Y5Mc6u
	ZxSfZd0sudb37vrreUuf/vxQNKFtm1nj4kWJIZvD0noOyTtdmvy+o7vndkZAxGMjtvD8qbN6
	uStYp1hrSkw7bTC9lkXjTJ3Zv8eLX97OO8T12HNR3pqn23fMSd2VIhCnpMRSnJFoqMVcVJwI
	AHmpBfRMAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HAVE_PWM symbol is only for legacy platforms that provide
the PWM API without using the generic framework. PXA platforms
use the generic PWM framework, after the commit "17b2b47 pwm:
Move PXA PWM driver to PWM framework".

In the case of "CONFIG_HAVE_PWM=y && CONFIG_PWM=n", PXA platforms
make the build errors as below. Thus, selecting HAVE_PWM should
be removed from PXA platforms.

drivers/built-in.o: In function `lm3630a_pwm_ctrl':
drivers/video/backlight/lm3630a_bl.c:168: undefined reference to `pwm_config'
drivers/video/backlight/lm3630a_bl.c:172: undefined reference to `pwm_disable'
drivers/video/backlight/lm3630a_bl.c:170: undefined reference to `pwm_enable'
drivers/built-in.o: In function `lp855x_pwm_ctrl':
drivers/video/backlight/lp855x_bl.c:249: undefined reference to `pwm_config'
drivers/video/backlight/lp855x_bl.c:253: undefined reference to `pwm_disable'
drivers/video/backlight/lp855x_bl.c:251: undefined reference to `pwm_enable'

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/arm/mach-pxa/Kconfig |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 96100db..b96244c 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -7,7 +7,6 @@ comment "Intel/Marvell Dev Platforms (sorted by hardware release time)"
 config MACH_PXA3XX_DT
 	bool "Support PXA3xx platforms from device tree"
 	select CPU_PXA300
-	select HAVE_PWM
 	select POWER_SUPPLY
 	select PXA3xx
 	select USE_OF
@@ -23,12 +22,10 @@ config ARCH_LUBBOCK
 
 config MACH_MAINSTONE
 	bool "Intel HCDDBBVA0 Development Platform (aka Mainstone)"
-	select HAVE_PWM
 	select PXA27x
 
 config MACH_ZYLONITE
 	bool
-	select HAVE_PWM
 	select PXA3xx
 
 config MACH_ZYLONITE300
@@ -69,7 +66,6 @@ config ARCH_PXA_IDP
 config ARCH_VIPER
 	bool "Arcom/Eurotech VIPER SBC"
 	select ARCOM_PCMCIA
-	select HAVE_PWM
 	select I2C_GPIO
 	select ISA
 	select PXA25x
@@ -120,7 +116,6 @@ config MACH_CM_X300
 	bool "CompuLab CM-X300 modules"
 	select CPU_PXA300
 	select CPU_PXA310
-	select HAVE_PWM
 	select PXA3xx
 
 config MACH_CAPC7117
@@ -211,7 +206,6 @@ config TRIZEPS_PCMCIA
 
 config MACH_LOGICPD_PXA270
 	bool "LogicPD PXA270 Card Engine Development Platform"
-	select HAVE_PWM
 	select PXA27x
 
 config MACH_PCM027
@@ -222,7 +216,6 @@ config MACH_PCM027
 config MACH_PCM990_BASEBOARD
 	bool "PHYTEC PCM-990 development board"
 	depends on MACH_PCM027
-	select HAVE_PWM
 
 choice
 	prompt "display on pcm990"
@@ -246,7 +239,6 @@ config MACH_COLIBRI
 config MACH_COLIBRI_PXA270_INCOME
 	bool "Income s.r.o. PXA270 SBC"
 	depends on MACH_COLIBRI
-	select HAVE_PWM
 	select PXA27x
 
 config MACH_COLIBRI300
@@ -275,7 +267,6 @@ comment "End-user Products (sorted by vendor name)"
 
 config MACH_H4700
 	bool "HP iPAQ hx4700"
-	select HAVE_PWM
 	select IWMMXT
 	select PXA27x
 
@@ -289,14 +280,12 @@ config MACH_HIMALAYA
 
 config MACH_MAGICIAN
 	bool "Enable HTC Magician Support"
-	select HAVE_PWM
 	select IWMMXT
 	select PXA27x
 
 config MACH_MIOA701
 	bool "Mitac Mio A701 Support"
 	select GPIO_SYSFS
-	select HAVE_PWM
 	select IWMMXT
 	select PXA27x
 	help
@@ -306,7 +295,6 @@ config MACH_MIOA701
 
 config PXA_EZX
 	bool "Motorola EZX Platform"
-	select HAVE_PWM
 	select IWMMXT
 	select PXA27x
 
@@ -346,7 +334,6 @@ config MACH_MP900C
 
 config ARCH_PXA_PALM
 	bool "PXA based Palm PDAs"
-	select HAVE_PWM
 
 config MACH_PALM27X
 	bool
@@ -444,7 +431,6 @@ config MACH_TREO680
 config MACH_RAUMFELD_RC
 	bool "Raumfeld Controller"
 	select CPU_PXA300
-	select HAVE_PWM
 	select POWER_SUPPLY
 	select PXA3xx
 
@@ -608,7 +594,6 @@ config MACH_E800
 
 config MACH_ZIPIT2
 	bool "Zipit Z2 Handheld"
-	select HAVE_PWM
 	select PXA27x
 endmenu
 
-- 
1.7.10.4


