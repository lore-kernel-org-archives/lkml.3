Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaE1EwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:52:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32404 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaE1EwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:52:03 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-b0-53856b6f18bd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com
Subject: [PATCH] extcon: Reorder the sequence of extcon device driver
 alphabetically
Date: Wed, 28 May 2014 13:51:54 +0900
Message-id: <1401252714-32150-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWyRsSkQDc/uzXYoOURl8X1L89ZLS7vmsNm
	cbtxBZsDs0ffllWMHp83yQUwRXHZpKTmZJalFunbJXBldM/7xFJwV7TiRM9DlgbG94JdjJwc
	EgImEn9uvmeEsMUkLtxbz9bFyMUhJLCUUWL646+MMEWnT/QzQyQWMUpsnNzMDuE0MUmcmL+W
	FaSKTUBLYv+LG2wgtoiAgsTm3mdgcWYBY4mpJ44zg9jCAmES2w5+ZQKxWQRUJVZdfM0OYvMK
	uEr0Tehjg9gmJ/FhzyN2CPsMm8TMucoQ9QIS3yYfYuli5ACKy0psOsAMUSIpcXDFDZYJjIIL
	GBlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgQG3Ol/z3p3MN4+YH2IMRlo3ERmKdHkfGDA
	5pXEGxqbGVmYmpgaG5lbmpEmrCTOm/QwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY7L3
	HRPd72c6ahNLlObP1CmuvMrsxF+jH6Gz6OXLt0+OfnvtmD/tdZE/G79GP4N+IJt7trh8rdC0
	PfprP0ioM980KWCP+f/wTMqa4+37PXaJr/Lu+56vaf+l1I1H4tfG1Be/w2u/nPNIXLhv5f6w
	hmpV2X+zDY0ljy6/VSNnrB3wZlqyr8VJJZbijERDLeai4kQA1VB9F04CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t9jAd387NZgg21PmSyuf3nOanF51xw2
	i9uNK9gcmD36tqxi9Pi8SS6AKaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJc
	SSEvMTfVVsnFJ0DXLTMHaImSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCG
	MaN73ieWgruiFSd6HrI0ML4X7GLk5JAQMJE4faKfGcIWk7hwbz1bFyMXh5DAIkaJjZOb2SGc
	JiaJE/PXsoJUsQloSex/cYMNxBYRUJDY3PsMLM4sYCwx9cRxsEnCAmES2w5+ZQKxWQRUJVZd
	fM0OYvMKuEr0Tehjg9gmJ/FhzyP2CYzcCxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIE
	B/Qz6R2MqxosDjEKcDAq8fAeWNwSLMSaWFZcmXuIUYKDWUmE909Aa7AQb0piZVVqUX58UWlO
	avEhxmSg7ROZpUST84HRllcSb2hsYmZkaWRuaGFkbE6asJI478FW60AhgfTEktTs1NSC1CKY
	LUwcnFINjC3Vdicv3Lr12z7PdYv7JCbZWx/EKoLnyX/zm7lw4s0e/oYPq764zNfftSAy/mac
	ZsX+xRuFEpYtcH9quOnidJXadIMfG3ZfY+D25Ln//oHSs6KV3Q08my1nbOa5FchcHV56msvu
	y6KJkwMFDCdJAWPhhOjHvb3ev+ykHn1xdv+ZGGp14Mena0osxRmJhlrMRcWJAMby8EGsAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorder the sequence of extcon device diver alphabetically
to imporbe readability.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/Kconfig  | 28 ++++++++++++++--------------
 drivers/extcon/Makefile |  6 +++---
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index aebde48..9125eba 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -14,6 +14,20 @@ if EXTCON
 
 comment "Extcon Device Drivers"
 
+config EXTCON_ADC_JACK
+	tristate "ADC Jack extcon support"
+	depends on IIO
+	help
+	  Say Y here to enable extcon device driver based on ADC values.
+
+config EXTCON_ARIZONA
+	tristate "Wolfson Arizona EXTCON support"
+	depends on MFD_ARIZONA && INPUT && SND_SOC
+	help
+	  Say Y here to enable support for external accessory detection
+	  with Wolfson Arizona devices. These are audio CODECs with
+	  advanced audio accessory detection support.
+
 config EXTCON_GPIO
 	tristate "GPIO extcon support"
 	depends on GPIOLIB
@@ -21,12 +35,6 @@ config EXTCON_GPIO
 	  Say Y here to enable GPIO based extcon support. Note that GPIO
 	  extcon supports single state per extcon instance.
 
-config EXTCON_ADC_JACK
-	tristate "ADC Jack extcon support"
-	depends on IIO
-	help
-	  Say Y here to enable extcon device driver based on ADC values.
-
 config EXTCON_MAX14577
 	tristate "MAX14577/77836 EXTCON Support"
 	depends on MFD_MAX14577
@@ -55,14 +63,6 @@ config EXTCON_MAX8997
 	  Maxim MAX8997 PMIC. The MAX8997 MUIC is a USB port accessory
 	  detector and switch.
 
-config EXTCON_ARIZONA
-	tristate "Wolfson Arizona EXTCON support"
-	depends on MFD_ARIZONA && INPUT && SND_SOC
-	help
-	  Say Y here to enable support for external accessory detection
-	  with Wolfson Arizona devices. These are audio CODECs with
-	  advanced audio accessory detection support.
-
 config EXTCON_PALMAS
 	tristate "Palmas USB EXTCON support"
 	depends on MFD_PALMAS
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index bf7861e..e48abc6 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -1,12 +1,12 @@
-#
+
 # Makefile for external connector class (extcon) devices
 #
 
 obj-$(CONFIG_EXTCON)		+= extcon-class.o
-obj-$(CONFIG_EXTCON_GPIO)	+= extcon-gpio.o
 obj-$(CONFIG_EXTCON_ADC_JACK)	+= extcon-adc-jack.o
+obj-$(CONFIG_EXTCON_ARIZONA)	+= extcon-arizona.o
+obj-$(CONFIG_EXTCON_GPIO)	+= extcon-gpio.o
 obj-$(CONFIG_EXTCON_MAX14577)	+= extcon-max14577.o
 obj-$(CONFIG_EXTCON_MAX77693)	+= extcon-max77693.o
 obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
-obj-$(CONFIG_EXTCON_ARIZONA)	+= extcon-arizona.o
 obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
-- 
1.8.0

