Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3HBFuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 01:50:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23794 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3HBFuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 01:50:17 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-17-51fb4898b156
From: Jingoo Han <jg1.han@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] mfd: menelaus: use NULL instead of 0
Date: Fri, 02 Aug 2013 14:50:15 +0900
Message-id: <000601ce8f44$299805e0$7cc811a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6PRB7uGOApXOEmQriQpVToyEBj0Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI90ZHr8DDU6uY7a4vPASq8X9r0cZ
	LS7vmsNmcbqb1YHF4861PWwe804GevRtWcXo8XmTXABLFJdNSmpOZllqkb5dAldG9+knTAUf
	OCqOLjjB3MC4l72LkZNDQsBEYu61g6wQtpjEhXvr2UBsIYFljBKbj4bD1Ky61MXYxcgFFF/E
	KDFtRgc7hPOLUeLfl4XMIFVsAmoSX74cBkpwcIgIeEncuhMEEmYWcJL4uWUmC4gtLGAqcfRq
	KxtICYuAqsS3m5YgYV4BS4k/Fw6zQ9iCEj8m32OBaNWSWL/zOBOELS+xec1bZoh7FCR2nH3N
	CGKLCOhJ7G2/xwxRIyKx78U7sDslBDaxS6z63wg2lEVAQOLb5EMsIHslBGQlNh2AmiMpcXDF
	DZYJjGKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSHxN2MF4
	74D1IcZkoPUTmaVEk/OB8ZlXEm9obGZkYWpiamxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpR
	fFFpTmrxIUYmDk6pBsb2VL1A0RYxvsxlOo/m2By9sOvG2o8yGmJm/y9t/yy1sypAQlZGgzXs
	ca3or8mSi8I4jqYEH2xbeLRn+iXOJUe25Cdpmy3/Lt1vuOldkf9JFu2POuuWG1a+9m7ZMeFA
	01seB3VzxjOvIl/N7L4r/5JPN7do58MTVVtmek5/YKPzIUhhzfy73hOUWIozEg21mIuKEwE6
	QHImxQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAd3pHr8DDZ69srG4vPASq8X9r0cZ
	LS7vmsNmcbqb1YHF4861PWwe804GevRtWcXo8XmTXABLVAOjTUZqYkpqkUJqXnJ+SmZeuq2S
	d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QRiWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYR1jRvfpJ0wFHzgqji44wdzAuJe9i5GTQ0LARGLVpS5GCFtM4sK99Wxd
	jFwcQgKLGCWmzehgh3B+MUr8+7KQGaSKTUBN4suXw0AJDg4RAS+JW3eCQMLMAk4SP7fMZAGx
	hQVMJY5ebWUDKWERUJX4dtMSJMwrYCnx58JhdghbUOLH5HssEK1aEut3HmeCsOUlNq95ywxx
	j4LEjrOvwW4TEdCT2Nt+jxmiRkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkZw/D6T2sG4ssHiEKMAB6MSD++DzF+BQqyJZcWVuYcYJTiYlUR4
	/8wGCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MLXklcQbGpuYGVkamVkYmZibkyasJM57
	oNU6UEggPbEkNTs1tSC1CGYLEwenVAOjIAeTzwVRK6Olt4UlYs4IV/UFv1go9oYrc4vc6cye
	OaYlp7gC352rMyhdZim8cI3trGVX77RYnDnXZmPmvG9/6d+SDOH2efvuLDTPm73m+KldQg6v
	5dkDgi/2RiuuSA/h98sr8b1/tcCIUdvg0oK1090n5G9PfcS33+LjkveM3zyN2ibPvqOqxFKc
	kWioxVxUnAgAd0WxTSMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'mmc_callback_data' and 'vtg' are pointers.
Fix the following sparse warning:

drivers/mfd/menelaus.c:445:43: warning: Using plain integer as NULL pointer
drivers/mfd/menelaus.c:469:20: warning: Using plain integer as NULL pointer

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/menelaus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 998ce8c..0f62ecd 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -442,7 +442,7 @@ void menelaus_unregister_mmc_callback(void)
 	menelaus_remove_irq_work(MENELAUS_MMC_S2D1_IRQ);
 
 	the_menelaus->mmc_callback = NULL;
-	the_menelaus->mmc_callback_data = 0;
+	the_menelaus->mmc_callback_data = NULL;
 }
 EXPORT_SYMBOL(menelaus_unregister_mmc_callback);
 
@@ -466,7 +466,7 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
 	struct i2c_client *c = the_menelaus->client;
 
 	mutex_lock(&the_menelaus->lock);
-	if (vtg == 0)
+	if (vtg == NULL)
 		goto set_voltage;
 
 	ret = menelaus_read_reg(vtg->vtg_reg);
-- 
1.7.10.4


