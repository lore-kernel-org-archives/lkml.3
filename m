Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaGWBk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 21:40:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32948 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaGWBky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 21:40:54 -0400
X-AuditID: cbfee68f-b7fef6d000003970-1c-53cf12a13b92
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: ckeepax@opensource.wolfsonmicro.com, gg@slimlogic.co.uk,
        k.kozlowski@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] extcon: Add missing REGMAP_I2C/REGMAP_IRQ dependency on extcon
 driver
Date: Wed, 23 Jul 2014 10:40:40 +0900
Message-id: <1406079640-28069-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <y@samsung.com>
References: <y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkWHeh0Plgg/ltMhb/ptxgt7j+5Tmr
	Rf8WF4vXLwwtzja9Ybe4vGsOm8XtxhVsDuweLyf+ZvPo27KK0WPqlL+MHp83yQWwRHHZpKTm
	ZJalFunbJXBldC69z1Lwn7uiZcEipgbGg5xdjJwcEgImEk9fvGOGsMUkLtxbz9bFyMUhJLCU
	UWL+ikVsMEU//txngUgsYpT4N2ERlNPEJNHVMZUVpIpNQEti/4sbYB0iAgoSm3ufsYIUMQts
	ZpS4efwY0A4ODmGBCIk3TS4gJouAqsTzKz4g5bwCrhKTPx1jh1gmJ/FhzyMwm1NARmLO7FVg
	tpCAtMT97h6wvRICk9klHq3aDJZgERCQ+Db5EAvITAkBWYlNB6C+kZQ4uOIGywRG4QWMDKsY
	RVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAgP79L9n/TsY7x6wPsSYDDRuIrOUaHI+MDLySuIN
	jc2MLExNTI2NzC3NSBNWEue9/zApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjDlWfs6vj
	EoL0Jc40tgrJ3g72cT09+YKf98KLzz/Nb2VeyaH1KGnqzJL+bxZ7Vv7lcnnv03Fky0Qurxul
	ymUzFrg23HjwzkKY1+6aRHTGuj9mhs59t76s3nHnmYmsttrCywu7M7i3cbN/jL4xTf+K0bc3
	SZduFT471/fiSd1unm+Zzxvj9FlXK7EUZyQaajEXFScCAOhA1JmCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t9jAd2FQueDDWbsE7H4N+UGu8X1L89Z
	Lfq3uFi8fmFocbbpDbvF5V1z2CxuN65gc2D3eDnxN5tH35ZVjB5Tp/xl9Pi8SS6AJaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0bn0vssBf+5K1oWLGJqYDzI2cXIySEh
	YCLx4899FghbTOLCvfVsXYxcHEICixgl/k1YxALhNDFJdHVMZQWpYhPQktj/4gYbiC0ioCCx
	ufcZK0gRs8BmRombx48xdzFycAgLREi8aXIBMVkEVCWeX/EBKecVcJWY/OkYO8QyOYkPex6B
	2ZwCMhJzZq8Cs4UEpCXud/ewTGDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOG6e
	Se9gXNVgcYhRgINRiYe3oOZcsBBrYllxZe4hRgkOZiUR3uhWoBBvSmJlVWpRfnxRaU5q8SFG
	U6CjJjJLiSbnA2M6ryTe0NjEzMjSyNzQwsjYXEmc92CrdaCQQHpiSWp2ampBahFMHxMHp1QD
	Y9j6o38XGr6PW68t/O7ikWXWFZfv8f1jOOX+36dy+vqvi9Mfei5qEXJRO7LxfV6n7pGrW5bk
	cE1tPcdaE6iycMFe+/LmxSwXO0MWra7pkO2wj7J5Lvv1DfupBPsbrNlP75utyPY0vX3p56lJ
	pwKW56XG3+A25zq/UOuV2aSA069UHr+LtbdOVFViKc5INNRiLipOBACtBI3JsQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add missing REGMAP_I2C/REGMAP_IRQ dependency on extcon provider
driver to protect build break.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 6f2f472..77577db 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -23,6 +23,7 @@ config EXTCON_ADC_JACK
 config EXTCON_ARIZONA
 	tristate "Wolfson Arizona EXTCON support"
 	depends on MFD_ARIZONA && INPUT && SND_SOC
+	select REGMAP_I2C
 	help
 	  Say Y here to enable support for external accessory detection
 	  with Wolfson Arizona devices. These are audio CODECs with
@@ -40,6 +41,7 @@ config EXTCON_MAX14577
 	depends on MFD_MAX14577
 	select IRQ_DOMAIN
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	help
 	  If you say yes here you get support for the MUIC device of
 	  Maxim MAX14577/77836. The MAX14577/77836 MUIC is a USB port accessory
@@ -50,6 +52,7 @@ config EXTCON_MAX77693
 	depends on MFD_MAX77693 && INPUT
 	select IRQ_DOMAIN
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	help
 	  If you say yes here you get support for the MUIC device of
 	  Maxim MAX77693 PMIC. The MAX77693 MUIC is a USB port accessory
@@ -66,6 +69,7 @@ config EXTCON_MAX8997
 config EXTCON_PALMAS
 	tristate "Palmas USB EXTCON support"
 	depends on MFD_PALMAS
+	select REGMAP_IRQ
 	help
 	  Say Y here to enable support for USB peripheral and USB host
 	  detection by palmas usb.
-- 
1.8.0

