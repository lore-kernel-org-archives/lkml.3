Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaCBFYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 00:24:01 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59768 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaCBFXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 00:23:07 -0500
From: Axel Rasmussen <axel.rasmussen1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 7/9] drivers: staging: rtl8187se: fixed checkpatch.pl errors
Date: Sat,  1 Mar 2014 22:22:51 -0700
Message-Id: <1393737773-13937-8-git-send-email-axel.rasmussen1@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of the driver's ChannelPlan array produced a large number
of checkpatch.pl errors. This patch fixes all of them by adding spaces
and wrapping the resulting overly-long lines.

Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c | 49 ++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 0630259..9e1642f 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -2242,17 +2242,44 @@ static void watch_dog_adaptive(unsigned long data)
 }
 
 static struct rtl8187se_channel_list channel_plan_list[] = {
-	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64},19},		/* FCC */
-	{{1,2,3,4,5,6,7,8,9,10,11},11},					/* IC */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* ETSI */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* Spain. Change to ETSI. */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* France. Change to ETSI. */
-	{{14,36,40,44,48,52,56,60,64},9},				/* MKK */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14, 36,40,44,48,52,56,60,64},22},/* MKK1 */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* Israel. */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,34,38,42,46},17},		/* For 11a , TELEC */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14},  /* For Global Domain. 1-11:active scan, 12-14 passive scan. //+YJ, 080626 */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13} /* world wide 13: ch1~ch11 active scan, ch12~13 passive //lzm add 080826 */
+	/* FCC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40,
+		44, 48, 52, 56, 60, 64}, 19},
+
+	/* IC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},
+
+	/* ETSI */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40,
+		44, 48, 52, 56, 60, 64}, 21},
+
+	/* Spain. Change to ETSI. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40,
+		44, 48, 52, 56, 60, 64}, 21},
+
+	/* France. Change to ETSI. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40,
+		44, 48, 52, 56, 60, 64}, 21},
+
+	/* MKK */
+	{{14, 36, 40, 44, 48, 52, 56, 60, 64}, 9},
+
+	/* MKK1 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36,
+		40, 44, 48, 52, 56, 60, 64}, 22},
+
+	/* Israel. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40,
+		44, 48, 52, 56, 60, 64}, 21},
+
+	/* For 11a , TELEC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 34, 38, 42, 46}, 17},
+
+	/* For Global Domain. 1-11 active, 12-14 passive. //+YJ, 080626 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 14},
+
+	/* world wide 13: ch1~ch11 active, ch12~13 passive //lzm add 080826 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13}
 };
 
 static void rtl8180_set_channel_map(u8 channel_plan,
-- 
1.8.3.2

