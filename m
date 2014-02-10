Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaBJBIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:08:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:63219 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaBJBI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:08:29 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-25-52f8268b0f10
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Eric Miao'" <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003901cf25fc$73002790$590076b0$%han@samsung.com>
In-reply-to: <003901cf25fc$73002790$590076b0$%han@samsung.com>
Subject: [PATCH 1/7] ARM: pxa: don't select HAVE_PWM
Date: Mon, 10 Feb 2014 10:08:27 +0900
Message-id: <003a01cf25fc$9ac5bbf0$d05133d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8l/GYGhOsBgXmsQoSPhLhnprg0iAAABfEA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zI91utR9BBteXW1r8nXSM3WJH23E2
	i8sLL7FaTPmznMli0+NrrBaXd81hs7h9mdeB3aOluYfN4/evSYweO2fdZfe4c20Pm8fmJfUe
	fVtWMXp83iQXwB7FZZOSmpNZllqkb5fAlXH58hWmgm3yFT+vnWZpYNwu2cXIySEhYCJx7vl9
	RghbTOLCvfVsXYxcHEICyxgl1nTdZoYpmnnyLCNEYhGjxPbfB6GcX4wSLVcms4BUsQmoSXz5
	cpgdxBYRUJY4/vIOC0gRs8A3Rolb36aAFQkJ2ErMbdgPVsQpYCcxb+k3VhBbGGhFx9prbCA2
	i4CqxL5/b8BqeIHqT31+zwZhC0r8mHwPbA6zgJbE+p3HmSBseYnNa94CncoBdKq6xKO/uhA3
	GEn8vbOYEaJERGLfi3dgR0sI/GSX6G2ZzAyxS0Di2+RDLBC9shKbDkB9LClxcMUNlgmMErOQ
	bJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZIRE/cwXj/gPUhxmSg
	9ROZpUST84EJIa8k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGN3yA9YvCeTiEe6OmZKybPfTg9e9+Y4b9rr03Jq+fGNqTMTPZbENOmZ2U4QWPZt+
	6iTr5fJ9b1yMTkmXZjCcmMZcetI/JfnHP90t65fdPuiz2f+h708dxvllsm5MraeLLISLUrhS
	QnteLnA+sWCv0QRF0/aQFwG/nWxuiH1oOBk4b+LJ1qyWk0osxRmJhlrMRcWJAEd5Yqv+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAd1utR9BBvOvmFj8nXSM3WJH23E2
	i8sLL7FaTPmznMli0+NrrBaXd81hs7h9mdeB3aOluYfN4/evSYweO2fdZfe4c20Pm8fmJfUe
	fVtWMXp83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj8uUrTAXb
	5Ct+XjvN0sC4XbKLkZNDQsBEYubJs4wQtpjEhXvr2boYuTiEBBYxSmz/fZARwvnFKNFyZTIL
	SBWbgJrEly+H2UFsEQFlieMv77CAFDELfGOUuPVtCliRkICtxNyG/WBFnAJ2EvOWfmMFsYWB
	1nWsvcYGYrMIqErs+/cGrIYXqP7U5/dsELagxI/J98DmMAtoSazfeZwJwpaX2LzmLXMXIwfQ
	qeoSj/7qQtxgJPH3zmJGiBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5
	hnrFibnFpXnpesn5uZsYwenimdQOxpUNFocYBTgYlXh4d/z5HiTEmlhWXJl7iFGCg1lJhPfl
	XaAQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wNTWV5JvKGxiZmRpZGZhZGJuTlpwkrivAda
	rQOFBNITS1KzU1MLUotgtjBxcEo1MMYf2/arvDK2tOleWHa4SdeClZWGPZ1/628XJh+TYVWf
	7ZbQEbO4id91t49ugupKMZ+DE/c6RTNwcbhGXtaa1TXjvKR8cqxDDMMr7YUdSxm+SzyaUxi4
	TW7CxU+/TjEcs60X+xISZVDloZTx2HPxSZWPSQfVwtZPm+KmXncz/Uy/9Y8HBc08SizFGYmG
	WsxFxYkA+mXhmVsDAAA=
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


