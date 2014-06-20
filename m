Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966551AbaFTRuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:50:12 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47896 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966335AbaFTRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:50:06 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, andrea.merello@gmail.com, anarey@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH 2/3] Staging: rtl8192u: r8192U_wx.c Fixed some more code-style warnings about spaces
Date: Fri, 20 Jun 2014 10:49:55 -0700
Message-Id: <1403286596-6756-2-git-send-email-c@24.io>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403286596-6756-1-git-send-email-c@24.io>
References: <1403286596-6756-1-git-send-email-c@24.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following warnings issued by checkpatch.pl

WARNING: please, no space before tabs

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/rtl8192u/r8192U_wx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index d061797..cccc88b 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -299,7 +299,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	/* range->retry_capa; */	/* What retry options are supported */
 	/* range->retry_flags; */	/* How to decode max/min retry limit */
 	/* range->r_time_flags; */	/* How to decode max/min retry life */
-	/* range->min_retry; */ 	/* Minimal number of retries */
+	/* range->min_retry; */		/* Minimal number of retries */
 	/* range->max_retry; */		/* Maximal number of retries */
 	/* range->min_r_time; */	/* Minimal retry lifetime */
 	/* range->max_r_time; */	/* Maximal retry lifetime */
@@ -802,7 +802,7 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 					alg,	/* KeyType */
 					(u8 *)ieee->ap_mac_addr,/* MacAddr */
 					0,			/* DefaultKey */
-					key);           	/* KeyContent */
+					key);			/* KeyContent */
 		}
 
 
-- 
1.9.1

