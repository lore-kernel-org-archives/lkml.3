Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaCMJjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:39:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33148 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaCMJjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:39:31 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-1e-53217cd2b990
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        cooloney@gmail.com, rpurdie@rpsys.net, dbaryshkov@gmail.com,
        dwmw2@infradead.org, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 3/4] mfd: max8997: change irq names to upper case
Date: Thu, 13 Mar 2014 10:38:51 +0100
Message-id: <1394703532-494-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t9jAd1LNYrBBo8WC1ksuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi9cvDC3ufz3KaPHtSgeTxc1P31gtLu+aw2ax
	9c06Rou1R+6yW9xuXMFmcW3vcWaLB4d3slvs3vWU1WJ/ZwejxeluVgcRj52z7rJ77Jl4ks1j
	8wotj02rOtk87lzbw+Yx72Sgx575P1g9+rasYvSYPu8nk8fnTXIe67dsZQrgjuKySUnNySxL
	LdK3S+DKOH1rKmvBDomKeb//MzUwvhLpYuTkkBAwkbj2fRojhC0mceHeerYuRi4OIYFFjBJt
	S9ugnHYmiXnHVzGBVLEJ6Ehs+T4BrENEQF/iw46rzCBFzAI3mSXmnOkHSwgLuEh0zOsBs1kE
	VCUm94GM5eDgFXCWWN2YDmJKCChIzJlkA1LBCVTdMH0FO0hYCKji7XGWCYy8CxgZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIER8Iz6R2MqxosDjEKcDAq8fCuWK4QLMSaWFZcmXuIUYKD
	WUmEd36lYrAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkG
	Rg6vyNDVHXOyev//UT/Jk+Vn+f3CYe39x7x0DCZ8uzalITJV3GTlgsqDF64z7E3ROcfh996m
	wFPqsahurPB2s6Q7Qssqfvudn/1d5RpX7J/3bYkT90drHj5buSBe9G2p7MM1sROPbkj49HcX
	e+ncQwuO+OYebIqyXb3166RkjZVdTgs8FaevrlRiKc5INNRiLipOBACmuG/BgAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes naming convention of MUIC interrupts form CamelCase
to upper case. It makes names more readable and consistent with another
interrupt names in max8997 driver.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-max8997.c     |   32 ++++++++++++++++----------------
 include/linux/mfd/max8997-private.h |   16 ++++++++--------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 5948061..15fc5c0 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -46,15 +46,15 @@ struct max8997_muic_irq {
 };
 
 static struct max8997_muic_irq muic_irqs[] = {
-	{ MAX8997_MUICIRQ_ADCError,	"muic-ADCERROR" },
-	{ MAX8997_MUICIRQ_ADCLow,	"muic-ADCLOW" },
-	{ MAX8997_MUICIRQ_ADC,		"muic-ADC" },
-	{ MAX8997_MUICIRQ_VBVolt,	"muic-VBVOLT" },
-	{ MAX8997_MUICIRQ_DBChg,	"muic-DBCHG" },
-	{ MAX8997_MUICIRQ_DCDTmr,	"muic-DCDTMR" },
-	{ MAX8997_MUICIRQ_ChgDetRun,	"muic-CHGDETRUN" },
-	{ MAX8997_MUICIRQ_ChgTyp,	"muic-CHGTYP" },
-	{ MAX8997_MUICIRQ_OVP,		"muic-OVP" },
+	{ MAX8997_MUICIRQ_ADCERROR,	"MUIC-ADCERROR" },
+	{ MAX8997_MUICIRQ_ADCLOW,	"MUIC-ADCLOW" },
+	{ MAX8997_MUICIRQ_ADC,		"MUIC-ADC" },
+	{ MAX8997_MUICIRQ_VBVOLT,	"MUIC-VBVOLT" },
+	{ MAX8997_MUICIRQ_DBCHG,	"MUIC-DBCHG" },
+	{ MAX8997_MUICIRQ_DCDTMR,	"MUIC-DCDTMR" },
+	{ MAX8997_MUICIRQ_CHGDETRUN,	"MUIC-CHGDETRUN" },
+	{ MAX8997_MUICIRQ_CHGTYP,	"MUIC-CHGTYP" },
+	{ MAX8997_MUICIRQ_OVP,		"MUIC-OVP" },
 };
 
 /* Define supported cable type */
@@ -553,17 +553,17 @@ static void max8997_muic_irq_work(struct work_struct *work)
 	}
 
 	switch (irq_type) {
-	case MAX8997_MUICIRQ_ADCError:
-	case MAX8997_MUICIRQ_ADCLow:
+	case MAX8997_MUICIRQ_ADCERROR:
+	case MAX8997_MUICIRQ_ADCLOW:
 	case MAX8997_MUICIRQ_ADC:
 		/* Handle all of cable except for charger cable */
 		ret = max8997_muic_adc_handler(info);
 		break;
-	case MAX8997_MUICIRQ_VBVolt:
-	case MAX8997_MUICIRQ_DBChg:
-	case MAX8997_MUICIRQ_DCDTmr:
-	case MAX8997_MUICIRQ_ChgDetRun:
-	case MAX8997_MUICIRQ_ChgTyp:
+	case MAX8997_MUICIRQ_VBVOLT:
+	case MAX8997_MUICIRQ_DBCHG:
+	case MAX8997_MUICIRQ_DCDTMR:
+	case MAX8997_MUICIRQ_CHGDETRUN:
+	case MAX8997_MUICIRQ_CHGTYP:
 		/* Handle charger cable */
 		ret = max8997_muic_chg_handler(info);
 		break;
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index f42ea22..2817fa6 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -411,14 +411,14 @@ enum max8997_irq {
 
 enum max8997_irq_muic {
 	MAX8997_MUICIRQ_ADC,
-	MAX8997_MUICIRQ_ADCLow,
-	MAX8997_MUICIRQ_ADCError,
-
-	MAX8997_MUICIRQ_ChgTyp,
-	MAX8997_MUICIRQ_ChgDetRun,
-	MAX8997_MUICIRQ_DCDTmr,
-	MAX8997_MUICIRQ_DBChg,
-	MAX8997_MUICIRQ_VBVolt,
+	MAX8997_MUICIRQ_ADCLOW,
+	MAX8997_MUICIRQ_ADCERROR,
+
+	MAX8997_MUICIRQ_CHGTYP,
+	MAX8997_MUICIRQ_CHGDETRUN,
+	MAX8997_MUICIRQ_DCDTMR,
+	MAX8997_MUICIRQ_DBCHG,
+	MAX8997_MUICIRQ_VBVOLT,
 
 	MAX8997_MUICIRQ_OVP,
 
-- 
1.7.9.5

