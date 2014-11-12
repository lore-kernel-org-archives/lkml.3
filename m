Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaKLHYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:24:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18235 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaKLHYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:24:01 -0500
X-AuditID: cbfee61a-f79c06d000004e71-22-54630b0f34d1
From: Robert Baldyga <r.baldyga@samsung.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        dmitry.torokhov@gmail.com, cooloney@gmail.com, rpurdie@rpsys.net,
        sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, sachin.kamat@linaro.org,
        k.kozlowski@samsung.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-pm@vger.kernel.org, rtc-linux@googlegroups.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v5 3/3] mfd: max8997: change irq names to upper case
Date: Wed, 12 Nov 2014 08:23:16 +0100
Message-id: <1415776996-11569-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415776996-11569-1-git-send-email-r.baldyga@samsung.com>
References: <1415776996-11569-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9jQV1+7uQQg8NPhS2WXLzKbjH14RM2
	i6M7JzJZXP/ynNVi0pP3zBaHF71gtJi4cjKzxesXhhb3vx5ltPh2pYPJ4uanb6wWl3fNYbPY
	+mYdo8Xn3iOMFrcbV7BZXNt7nNniweGd7Ba7dz1ltdjf2cFocfJPL6PF6W5Wi9O7SxzEPHbO
	usvusWfiSTaPzSu0PDat6mTzuHNtD5vHvJOBHnvm/2D16NuyitFj+ryfTB6fN8l5rN+ylSmA
	O4rLJiU1J7MstUjfLoErY/bq/IINkhWHL99namC8KtrFyMkhIWAicav5BSOELSZx4d56ti5G
	Lg4hgemMEu+uvGWFcNqZJI72HGEDqWIT0JHY8n0CWIeIgITExh99LCBFzAKzWSRevH4EViQs
	4CKx4EMnmM0ioCrxZGsHmM0r4CqxeNdHVoh1chInj00GszkF3CT6bh1kAbGFgGrmPXvHNoGR
	dwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Ph4JrWDcWWDxSFGAQ5GJR7exDVJIUKs
	iWXFlbmHGCU4mJVEeD99BQrxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQ
	WgSTZeLglGpgZFhy3yfs2uvTZrWLD2WvDtj1/c2mxjKFmtq5+0XOxJY0P23U+fS5QTZtgr3X
	tPnL5lUb7DR5vfOd5qknyecPm0jJLnps5HVll9H6pQELmBj8OD33VXaFaf0ur+0O1TqROtN6
	g85Po78XWJ/os/vbm7/VNZrDVN/y0bY5Niz59z3rlX48m5dNVGIpzkg01GIuKk4EANUsX9qL	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes naming convention of MUIC interrupts form CamelCase
to upper case. It makes names more readable and consistent with another
interrupt names in max8997 driver.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

[For the mfd part]
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/extcon/extcon-max8997.c     | 32 ++++++++++++++++----------------
 include/linux/mfd/max8997-private.h | 16 ++++++++--------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 172dbd6..834b72f 100644
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
1.9.1

