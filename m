Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaI3Rz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:55:59 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33020 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaI3Rz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:55:58 -0400
From: Karthik Nayak <karthik.188@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gamerh2o@gmail.com, gregkh@linuxfoundation.org,
        mark.einon@gmail.com, Karthik Nayak <karthik.188@gmail.com>
Subject: [PATCH] staging: et131x: remove unneccessary 'out of memory' message
Date: Tue, 30 Sep 2014 23:25:43 +0530
Message-Id: <1412099743-3893-1-git-send-email-karthik.188@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the 'out of memory' warning issued by checkpatch

Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
---
 drivers/staging/et131x/et131x.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 41fcaa0..f92cceb 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -2422,10 +2422,8 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 	rfd->len = len;
 
 	skb = dev_alloc_skb(rfd->len + 2);
-	if (!skb) {
-		dev_err(&adapter->pdev->dev, "Couldn't alloc an SKB for Rx\n");
+	if (!skb)
 		return NULL;
-	}
 
 	adapter->netdev->stats.rx_bytes += rfd->len;
 
-- 
2.1.0

