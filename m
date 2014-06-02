Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaFBQLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:11:54 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:45420 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaFBQLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:11:52 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com,
        andrea.merello@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 3/4] Staging: rtl8192u: r8192U_wx.c Added a single space for code-style issue
Date: Mon,  2 Jun 2014 09:11:44 -0700
Message-Id: <1401725505-3459-3-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401725505-3459-1-git-send-email-c@24.io>
References: <1401725505-3459-1-git-send-email-c@24.io>
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

