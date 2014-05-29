Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbaE2Upc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:45:32 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60413 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbaE2Up3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:45:29 -0400
From: Chaitanya Hazarey <c@24.io>
To: dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        burzalodowa@gmail.com, andrea.merello@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 4/5] Staging: rtl8192u: r8192U_wx.c Added a single space  for code-style issue
Date: Thu, 29 May 2014 13:45:20 -0700
Message-Id: <1401396321-29363-4-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401396321-29363-1-git-send-email-c@24.io>
References: <1401396321-29363-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a space around '|' to address:

ERROR: need consistent spacing around '|' (ctx:VxW)

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_wx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index b533784..09b1e81 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -987,7 +987,7 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 	wstats->qual.level = tmp_level;
 	wstats->qual.qual = tmp_qual;
 	wstats->qual.noise = tmp_noise;
-	wstats->qual.updated = IW_QUAL_ALL_UPDATED| IW_QUAL_DBM;
+	wstats->qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
 	return wstats;
 }
 
-- 
1.9.1

