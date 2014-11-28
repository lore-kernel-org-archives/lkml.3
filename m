Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaK1M4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:56:17 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34843 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaK1M4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:56:15 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: mdcasey@chabloom.com, mahati.chamarthy@gmail.com,
        andreas.frembs@studium.uni-erlangen.de, peter.senna@gmail.com,
        emilgoode@gmail.com, tapaswenipathak@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:staging:rtl8192e: Fixed checkpatch warning
Date: Fri, 28 Nov 2014 18:26:13 +0530
Message-Id: <1417179373-19458-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch warning:
WARNING: space prohibited before semicolon

Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
---
 drivers/staging/rtl8192e/rtllib_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index ca76ad0..cf11b04 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -2687,7 +2687,7 @@ void rtllib_rx_mgt(struct rtllib_device *ieee,
 		      struct sk_buff *skb,
 		      struct rtllib_rx_stats *stats)
 {
-	struct rtllib_hdr_4addr *header = (struct rtllib_hdr_4addr *)skb->data ;
+	struct rtllib_hdr_4addr *header = (struct rtllib_hdr_4addr *)skb->data;
 
 	if ((WLAN_FC_GET_STYPE(le16_to_cpu(header->frame_ctl)) !=
 	    RTLLIB_STYPE_PROBE_RESP) &&
-- 
1.7.9.5

