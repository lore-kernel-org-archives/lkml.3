Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbbA2Ipv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:45:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8895 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbbA2Ipp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:45:45 -0500
X-AuditID: cbfee68f-f791c6d000004834-3b-54c9f335363d
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Inki Dae <inki.dae@samsung.com>, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 2/2] extcon: max77693: Fix cable name of USB-HOST
Date: Thu, 29 Jan 2015 17:45:24 +0900
Message-id: <1422521124-508-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1422521124-508-1-git-send-email-jaewon02.kim@samsung.com>
References: <1422521124-508-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsWyRsSkQNf088kQg+9vjS2uf3nOajHp/gQW
	ix0NR1gtLu+aw+bA4tG3ZRWjx+dNcgFMUVw2Kak5mWWpRfp2CVwZ0xd/ZS/okq5YOf8newPj
	SZEuRk4OCQETidt/v7BD2GISF+6tZwOxhQSWMkpcOKQNU3O47R5rFyMXUHw6o8Sc2fvZIZw2
	JokZrS9YQKrYBLQlvq9fzApiiwi4SXz79IcZxGYW8JLYcXktI4gtLOAo8X7bM7ANLAKqEm/O
	rAbbzAtU37vlLFA9B9A2BYk5k2xAwpwC7hJz7s1lgTjITeLdxhksIHslBN6zSSw6t4YdYo6A
	xLfJh1ggemUlNh1ghjhaUuLgihssExiFFzAyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQI
	DNTT/57172C8e8D6EKMAB6MSD29C48kQIdbEsuLK3EOMpkAbJjJLiSbnA+MhryTe0NjMyMLU
	xNTYyNzSTEmcd6HUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjH7zhE9N3z398N7P9/au
	ctxlfz5pzezlda6J1R08qUqTM1k/y1Qlz918p6nqV8Z/s4iuPauerNzNkzOH89GZksgr6qpr
	Nbcu+vZrq+neK6EuWT2/Le73mLI/EZwiu9c5iXPSZJ5rBdIpHBXO6Svi0udFC4XzBX/8zfcy
	2OqNbmCH9/XYl222M5VYijMSDbWYi4oTAc+Wks5PAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xoK7p55MhBj+n61hc//Kc1WLS/Qks
	FjsajrBaXN41h82BxaNvyypGj8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYM6Yv/spe0CVdsXL+T/YGxpMiXYycHBICJhKH2+6xQthiEhfurWfrYuTiEBKYzigx
	Z/Z+dginjUliRusLFpAqNgFtie/rF4N1iAi4SXz79IcZxGYW8JLYcXktI4gtLOAo8X7bMzYQ
	m0VAVeLNmdXsIDYvUH3vlrNA9RxA2xQk5kyyAQlzCrhLzLk3F2y8EFDJu40zWCYw8i5gZFjF
	KJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwJz6R3MK5qsDjEKMDBqMTDm9B4MkSINbGsuDL3
	EKMEB7OSCK/4G6AQb0piZVVqUX58UWlOavEhRlOgoyYyS4km5wOjNK8k3tDYxMzI0sjc0MLI
	2FxJnFfJvi1ESCA9sSQ1OzW1ILUIpo+Jg1OqgVF9/fNrubXnllz+1d5reOXxW7uj8hPzpz5g
	sui0OPH3dmvPbkvWYL27i+6sYth9bXPADUev+as+X0hWDkubK73Aub/FLno2d3z183VCXDsZ
	dLc+jWwuXfPe0e6Dx9n2VJdNtdM1Ne6xrHDnjEnn+VU1LyW67ax9xkznP6XveT7cVXpnffzA
	mQlKLMUZiYZazEXFiQDB2OgEmgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies the term called 'USB_OTG' and 'USB_HOST'
into USB_HOST. OTG(On-The-Go) function supports USB host and
this driver sents 'USB-Host event. So, unifies term to USB_HOST.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 drivers/extcon/extcon-max77693.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 1c2af58..b1d95aa 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -190,8 +190,8 @@ enum max77693_muic_acc_type {
 	/* The below accessories have same ADC value so ADCLow and
 	   ADC1K bit is used to separate specific accessory */
 						/* ADC|VBVolot|ADCLow|ADC1K| */
-	MAX77693_MUIC_GND_USB_OTG = 0x100,	/* 0x0|      0|     0|    0| */
-	MAX77693_MUIC_GND_USB_OTG_VB = 0x104,	/* 0x0|      1|     0|    0| */
+	MAX77693_MUIC_GND_USB_HOST = 0x100,	/* 0x0|      0|     0|    0| */
+	MAX77693_MUIC_GND_USB_HOST_VB = 0x104,	/* 0x0|      1|     0|    0| */
 	MAX77693_MUIC_GND_AV_CABLE_LOAD = 0x102,/* 0x0|      0|     1|    0| */
 	MAX77693_MUIC_GND_MHL = 0x103,		/* 0x0|      0|     1|    1| */
 	MAX77693_MUIC_GND_MHL_VB = 0x107,	/* 0x0|      1|     1|    1| */
@@ -403,8 +403,8 @@ static int max77693_muic_get_cable_type(struct max77693_muic_info *info,
 
 			/**
 			 * [0x1|VBVolt|ADCLow|ADC1K]
-			 * [0x1|     0|     0|    0] USB_OTG
-			 * [0x1|     1|     0|    0] USB_OTG_VB
+			 * [0x1|     0|     0|    0] USB_HOST
+			 * [0x1|     1|     0|    0] USB_HSOT_VB
 			 * [0x1|     0|     1|    0] Audio Video cable with load
 			 * [0x1|     0|     1|    1] MHL without charging cable
 			 * [0x1|     1|     1|    1] MHL with charging cable
@@ -523,7 +523,7 @@ static int max77693_muic_dock_handler(struct max77693_muic_info *info,
 		 * - Support charging and data connection through micro-usb port
 		 *           if USB cable is connected between target and host
 		 *	     device.
-		 * - Support OTG device (Mouse/Keyboard)
+		 * - Support OTG(On-The-Go) device (Ex: Mouse/Keyboard)
 		 */
 		ret = max77693_muic_set_path(info, info->path_usb, attached);
 		if (ret < 0)
@@ -609,9 +609,9 @@ static int max77693_muic_adc_ground_handler(struct max77693_muic_info *info)
 				MAX77693_CABLE_GROUP_ADC_GND, &attached);
 
 	switch (cable_type_gnd) {
-	case MAX77693_MUIC_GND_USB_OTG:
-	case MAX77693_MUIC_GND_USB_OTG_VB:
-		/* USB_OTG, PATH: AP_USB */
+	case MAX77693_MUIC_GND_USB_HOST:
+	case MAX77693_MUIC_GND_USB_HOST_VB:
+		/* USB_HOST, PATH: AP_USB */
 		ret = max77693_muic_set_path(info, CONTROL1_SW_USB, attached);
 		if (ret < 0)
 			return ret;
@@ -704,7 +704,7 @@ static int max77693_muic_adc_handler(struct max77693_muic_info *info)
 
 	switch (cable_type) {
 	case MAX77693_MUIC_ADC_GROUND:
-		/* USB_OTG/MHL/Audio */
+		/* USB_HOST/MHL/Audio */
 		max77693_muic_adc_ground_handler(info);
 		break;
 	case MAX77693_MUIC_ADC_FACTORY_MODE_USB_OFF:
@@ -886,7 +886,7 @@ static int max77693_muic_chg_handler(struct max77693_muic_info *info)
 			 * - Support charging and data connection through micro-
 			 *   usb port if USB cable is connected between target
 			 *   and host device
-			 * - Support OTG device (Mouse/Keyboard)
+			 * - Support OTG(On-The-Go) device (Ex: Mouse/Keyboard)
 			 */
 			ret = max77693_muic_set_path(info, info->path_usb,
 						    attached);
-- 
1.7.9.5

