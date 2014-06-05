Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaFEU0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:26:05 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:40017 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaFEU0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:26:02 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com,
        peter.p.waskiewicz.jr@intel.com, anarey@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 1/3] Staging: rtl8192u: r8192U_core.c Added a space after ','
Date: Thu,  5 Jun 2014 13:25:56 -0700
Message-Id: <1401999958-17235-1-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added spaces after ',' to fix the following warning:

ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_core.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 24272c5..2a9150d 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -166,17 +166,17 @@ typedef struct _CHANNEL_LIST {
 } CHANNEL_LIST, *PCHANNEL_LIST;
 
 static CHANNEL_LIST ChannelPlan[] = {
-	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64,149,153,157,161,165},24},		//FCC
-	{{1,2,3,4,5,6,7,8,9,10,11},11},							//IC
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	//ETSI
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13},    //Spain. Change to ETSI.
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13},	//France. Change to ETSI.
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14,36,40,44,48,52,56,60,64},22},	//MKK					//MKK
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14,36,40,44,48,52,56,60,64},22},//MKK1
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13},	//Israel.
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14,36,40,44,48,52,56,60,64},22},			// For 11a , TELEC
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14,36,40,44,48,52,56,60,64}, 22},    //MIC
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14}					//For Global Domain. 1-11:active scan, 12-14 passive scan. //+YJ, 080626
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40, 44, 48, 52, 56, 60, 64, 149, 153, 157, 161, 165}, 24},		//FCC
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},							//IC
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	//ETSI
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},    //Spain. Change to ETSI.
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},	//France. Change to ETSI.
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},	//MKK					//MKK
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},//MKK1
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13},	//Israel.
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},			// For 11a , TELEC
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},    //MIC
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 14}					//For Global Domain. 1-11:active scan, 12-14 passive scan. //+YJ, 080626
 };
 
 static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
-- 
1.9.1

