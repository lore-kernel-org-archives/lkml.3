Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaHXWvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 18:51:40 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:63927 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbaHXWvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 18:51:39 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>, Ana Rey <anarey@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Chaitanya Hazarey <c@24.io>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8192u: Fix switch and case should be at the same indent errors
Date: Sun, 24 Aug 2014 17:51:32 -0500
Message-Id: <1408920692-25704-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl switch and case should be at the same indent errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8192u/r8192U_core.c | 510 ++++++++++++++++-----------------
 1 file changed, 252 insertions(+), 258 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index eb96bed..3707d03 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1071,83 +1071,83 @@ static void rtl8192_config_rate(struct net_device *dev, u16 *rate_config)
 	for (i = 0; i < net->rates_len; i++) {
 		basic_rate = net->rates[i]&0x7f;
 		switch (basic_rate) {
-			case MGN_1M:
-				*rate_config |= RRSR_1M;
-				break;
-			case MGN_2M:
-				*rate_config |= RRSR_2M;
-				break;
-			case MGN_5_5M:
-				*rate_config |= RRSR_5_5M;
-				break;
-			case MGN_11M:
-				*rate_config |= RRSR_11M;
-				break;
-			case MGN_6M:
-				*rate_config |= RRSR_6M;
-				break;
-			case MGN_9M:
-				*rate_config |= RRSR_9M;
-				break;
-			case MGN_12M:
-				*rate_config |= RRSR_12M;
-				break;
-			case MGN_18M:
-				*rate_config |= RRSR_18M;
-				break;
-			case MGN_24M:
-				*rate_config |= RRSR_24M;
-				break;
-			case MGN_36M:
-				*rate_config |= RRSR_36M;
-				break;
-			case MGN_48M:
-				*rate_config |= RRSR_48M;
-				break;
-			case MGN_54M:
-				*rate_config |= RRSR_54M;
-				break;
+		case MGN_1M:
+			*rate_config |= RRSR_1M;
+			break;
+		case MGN_2M:
+			*rate_config |= RRSR_2M;
+			break;
+		case MGN_5_5M:
+			*rate_config |= RRSR_5_5M;
+			break;
+		case MGN_11M:
+			*rate_config |= RRSR_11M;
+			break;
+		case MGN_6M:
+			*rate_config |= RRSR_6M;
+			break;
+		case MGN_9M:
+			*rate_config |= RRSR_9M;
+			break;
+		case MGN_12M:
+			*rate_config |= RRSR_12M;
+			break;
+		case MGN_18M:
+			*rate_config |= RRSR_18M;
+			break;
+		case MGN_24M:
+			*rate_config |= RRSR_24M;
+			break;
+		case MGN_36M:
+			*rate_config |= RRSR_36M;
+			break;
+		case MGN_48M:
+			*rate_config |= RRSR_48M;
+			break;
+		case MGN_54M:
+			*rate_config |= RRSR_54M;
+			break;
 		}
 	}
 	for (i = 0; i < net->rates_ex_len; i++) {
 		basic_rate = net->rates_ex[i]&0x7f;
 		switch (basic_rate) {
-			case MGN_1M:
-				*rate_config |= RRSR_1M;
-				break;
-			case MGN_2M:
-				*rate_config |= RRSR_2M;
-				break;
-			case MGN_5_5M:
-				*rate_config |= RRSR_5_5M;
-				break;
-			case MGN_11M:
-				*rate_config |= RRSR_11M;
-				break;
-			case MGN_6M:
-				*rate_config |= RRSR_6M;
-				break;
-			case MGN_9M:
-				*rate_config |= RRSR_9M;
-				break;
-			case MGN_12M:
-				*rate_config |= RRSR_12M;
-				break;
-			case MGN_18M:
-				*rate_config |= RRSR_18M;
-				break;
-			case MGN_24M:
-				*rate_config |= RRSR_24M;
-				break;
-			case MGN_36M:
-				*rate_config |= RRSR_36M;
-				break;
-			case MGN_48M:
-				*rate_config |= RRSR_48M;
-				break;
-			case MGN_54M:
-				*rate_config |= RRSR_54M;
-				break;
+		case MGN_1M:
+			*rate_config |= RRSR_1M;
+			break;
+		case MGN_2M:
+			*rate_config |= RRSR_2M;
+			break;
+		case MGN_5_5M:
+			*rate_config |= RRSR_5_5M;
+			break;
+		case MGN_11M:
+			*rate_config |= RRSR_11M;
+			break;
+		case MGN_6M:
+			*rate_config |= RRSR_6M;
+			break;
+		case MGN_9M:
+			*rate_config |= RRSR_9M;
+			break;
+		case MGN_12M:
+			*rate_config |= RRSR_12M;
+			break;
+		case MGN_18M:
+			*rate_config |= RRSR_18M;
+			break;
+		case MGN_24M:
+			*rate_config |= RRSR_24M;
+			break;
+		case MGN_36M:
+			*rate_config |= RRSR_36M;
+			break;
+		case MGN_48M:
+			*rate_config |= RRSR_48M;
+			break;
+		case MGN_54M:
+			*rate_config |= RRSR_54M;
+			break;
 		}
 	}
 }
@@ -1371,98 +1371,98 @@ static u8 MRateToHwRate8190Pci(u8 rate)
 	u8  ret = DESC90_RATE1M;
 
 	switch (rate) {
-		case MGN_1M:
-			ret = DESC90_RATE1M;
-			break;
-		case MGN_2M:
-			ret = DESC90_RATE2M;
-			break;
-		case MGN_5_5M:
-			ret = DESC90_RATE5_5M;
-			break;
-		case MGN_11M:
-			ret = DESC90_RATE11M;
-			break;
-		case MGN_6M:
-			ret = DESC90_RATE6M;
-			break;
-		case MGN_9M:
-			ret = DESC90_RATE9M;
-			break;
-		case MGN_12M:
-			ret = DESC90_RATE12M;
-			break;
-		case MGN_18M:
-			ret = DESC90_RATE18M;
-			break;
-		case MGN_24M:
-			ret = DESC90_RATE24M;
-			break;
-		case MGN_36M:
-			ret = DESC90_RATE36M;
-			break;
-		case MGN_48M:
-			ret = DESC90_RATE48M;
-			break;
-		case MGN_54M:
-			ret = DESC90_RATE54M;
-			break;
+	case MGN_1M:
+		ret = DESC90_RATE1M;
+		break;
+	case MGN_2M:
+		ret = DESC90_RATE2M;
+		break;
+	case MGN_5_5M:
+		ret = DESC90_RATE5_5M;
+		break;
+	case MGN_11M:
+		ret = DESC90_RATE11M;
+		break;
+	case MGN_6M:
+		ret = DESC90_RATE6M;
+		break;
+	case MGN_9M:
+		ret = DESC90_RATE9M;
+		break;
+	case MGN_12M:
+		ret = DESC90_RATE12M;
+		break;
+	case MGN_18M:
+		ret = DESC90_RATE18M;
+		break;
+	case MGN_24M:
+		ret = DESC90_RATE24M;
+		break;
+	case MGN_36M:
+		ret = DESC90_RATE36M;
+		break;
+	case MGN_48M:
+		ret = DESC90_RATE48M;
+		break;
+	case MGN_54M:
+		ret = DESC90_RATE54M;
+		break;
 
-		// HT rate since here
-		case MGN_MCS0:
-			ret = DESC90_RATEMCS0;
-			break;
-		case MGN_MCS1:
-			ret = DESC90_RATEMCS1;
-			break;
-		case MGN_MCS2:
-			ret = DESC90_RATEMCS2;
-			break;
-		case MGN_MCS3:
-			ret = DESC90_RATEMCS3;
-			break;
-		case MGN_MCS4:
-			ret = DESC90_RATEMCS4;
-			break;
-		case MGN_MCS5:
-			ret = DESC90_RATEMCS5;
-			break;
-		case MGN_MCS6:
-			ret = DESC90_RATEMCS6;
-			break;
-		case MGN_MCS7:
-			ret = DESC90_RATEMCS7;
-			break;
-		case MGN_MCS8:
-			ret = DESC90_RATEMCS8;
-			break;
-		case MGN_MCS9:
-			ret = DESC90_RATEMCS9;
-			break;
-		case MGN_MCS10:
-			ret = DESC90_RATEMCS10;
-			break;
-		case MGN_MCS11:
-			ret = DESC90_RATEMCS11;
-			break;
-		case MGN_MCS12:
-			ret = DESC90_RATEMCS12;
-			break;
-		case MGN_MCS13:
-			ret = DESC90_RATEMCS13;
-			break;
-		case MGN_MCS14:
-			ret = DESC90_RATEMCS14;
-			break;
-		case MGN_MCS15:
-			ret = DESC90_RATEMCS15;
-			break;
-		case (0x80|0x20):
-			ret = DESC90_RATEMCS32;
-			break;
+	/* HT rate since here */
+	case MGN_MCS0:
+		ret = DESC90_RATEMCS0;
+		break;
+	case MGN_MCS1:
+		ret = DESC90_RATEMCS1;
+		break;
+	case MGN_MCS2:
+		ret = DESC90_RATEMCS2;
+		break;
+	case MGN_MCS3:
+		ret = DESC90_RATEMCS3;
+		break;
+	case MGN_MCS4:
+		ret = DESC90_RATEMCS4;
+		break;
+	case MGN_MCS5:
+		ret = DESC90_RATEMCS5;
+		break;
+	case MGN_MCS6:
+		ret = DESC90_RATEMCS6;
+		break;
+	case MGN_MCS7:
+		ret = DESC90_RATEMCS7;
+		break;
+	case MGN_MCS8:
+		ret = DESC90_RATEMCS8;
+		break;
+	case MGN_MCS9:
+		ret = DESC90_RATEMCS9;
+		break;
+	case MGN_MCS10:
+		ret = DESC90_RATEMCS10;
+		break;
+	case MGN_MCS11:
+		ret = DESC90_RATEMCS11;
+		break;
+	case MGN_MCS12:
+		ret = DESC90_RATEMCS12;
+		break;
+	case MGN_MCS13:
+		ret = DESC90_RATEMCS13;
+		break;
+	case MGN_MCS14:
+		ret = DESC90_RATEMCS14;
+		break;
+	case MGN_MCS15:
+		ret = DESC90_RATEMCS15;
+		break;
+	case (0x80|0x20):
+		ret = DESC90_RATEMCS32;
+		break;
 
-		default:
-			break;
+	default:
+		break;
 	}
 	return ret;
 }
@@ -4314,102 +4314,96 @@ UpdateReceivedRateHistogramStatistics8190(struct net_device *dev,
 		preamble_guardinterval = 0;// long
 
 	switch (stats->rate) {
-		//
-		// CCK rate
-		//
-		case MGN_1M:
-			rateIndex = 0;
-			break;
-		case MGN_2M:
-			rateIndex = 1;
-			break;
-		case MGN_5_5M:
-			rateIndex = 2;
-			break;
-		case MGN_11M:
-			rateIndex = 3;
-			break;
-		//
-		// Legacy OFDM rate
-		//
-		case MGN_6M:
-			rateIndex = 4;
-			break;
-		case MGN_9M:
-			rateIndex = 5;
-			break;
-		case MGN_12M:
-			rateIndex = 6;
-			break;
-		case MGN_18M:
-			rateIndex = 7;
-			break;
-		case MGN_24M:
-			rateIndex = 8;
-			break;
-		case MGN_36M:
-			rateIndex = 9;
-			break;
-		case MGN_48M:
-			rateIndex = 10;
-			break;
-		case MGN_54M:
-			rateIndex = 11;
-			break;
-		//
-		// 11n High throughput rate
-		//
-		case MGN_MCS0:
-			rateIndex = 12;
-			break;
-		case MGN_MCS1:
-			rateIndex = 13;
-			break;
-		case MGN_MCS2:
-			rateIndex = 14;
-			break;
-		case MGN_MCS3:
-			rateIndex = 15;
-			break;
-		case MGN_MCS4:
-			rateIndex = 16;
-			break;
-		case MGN_MCS5:
-			rateIndex = 17;
-			break;
-		case MGN_MCS6:
-			rateIndex = 18;
-			break;
-		case MGN_MCS7:
-			rateIndex = 19;
-			break;
-		case MGN_MCS8:
-			rateIndex = 20;
-			break;
-		case MGN_MCS9:
-			rateIndex = 21;
-			break;
-		case MGN_MCS10:
-			rateIndex = 22;
-			break;
-		case MGN_MCS11:
-			rateIndex = 23;
-			break;
-		case MGN_MCS12:
-			rateIndex = 24;
-			break;
-		case MGN_MCS13:
-			rateIndex = 25;
-			break;
-		case MGN_MCS14:
-			rateIndex = 26;
-			break;
-		case MGN_MCS15:
-			rateIndex = 27;
-			break;
-		default:
-			rateIndex = 28;
-			break;
+	/* CCK rate */
+	case MGN_1M:
+		rateIndex = 0;
+		break;
+	case MGN_2M:
+		rateIndex = 1;
+		break;
+	case MGN_5_5M:
+		rateIndex = 2;
+		break;
+	case MGN_11M:
+		rateIndex = 3;
+		break;
+	/* Legacy OFDM rate */
+	case MGN_6M:
+		rateIndex = 4;
+		break;
+	case MGN_9M:
+		rateIndex = 5;
+		break;
+	case MGN_12M:
+		rateIndex = 6;
+		break;
+	case MGN_18M:
+		rateIndex = 7;
+		break;
+	case MGN_24M:
+		rateIndex = 8;
+		break;
+	case MGN_36M:
+		rateIndex = 9;
+		break;
+	case MGN_48M:
+		rateIndex = 10;
+		break;
+	case MGN_54M:
+		rateIndex = 11;
+		break;
+	/* 11n High throughput rate */
+	case MGN_MCS0:
+		rateIndex = 12;
+		break;
+	case MGN_MCS1:
+		rateIndex = 13;
+		break;
+	case MGN_MCS2:
+		rateIndex = 14;
+		break;
+	case MGN_MCS3:
+		rateIndex = 15;
+		break;
+	case MGN_MCS4:
+		rateIndex = 16;
+		break;
+	case MGN_MCS5:
+		rateIndex = 17;
+		break;
+	case MGN_MCS6:
+		rateIndex = 18;
+		break;
+	case MGN_MCS7:
+		rateIndex = 19;
+		break;
+	case MGN_MCS8:
+		rateIndex = 20;
+		break;
+	case MGN_MCS9:
+		rateIndex = 21;
+		break;
+	case MGN_MCS10:
+		rateIndex = 22;
+		break;
+	case MGN_MCS11:
+		rateIndex = 23;
+		break;
+	case MGN_MCS12:
+		rateIndex = 24;
+		break;
+	case MGN_MCS13:
+		rateIndex = 25;
+		break;
+	case MGN_MCS14:
+		rateIndex = 26;
+		break;
+	case MGN_MCS15:
+		rateIndex = 27;
+		break;
+	default:
+		rateIndex = 28;
+		break;
 	}
 	priv->stats.received_preamble_GI[preamble_guardinterval][rateIndex]++;
 	priv->stats.received_rate_histogram[0][rateIndex]++; //total
-- 
1.9.1

