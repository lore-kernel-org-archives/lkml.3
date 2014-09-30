Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaI3RUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:20:05 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35453 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaI3RUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:20:02 -0400
From: Karthik Nayak <karthik.188@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gamerh2o@gmail.com, gregkh@linuxfoundation.org,
        mark.einon@gmail.com, Karthik Nayak <karthik.188@gmail.com>
Subject: [PATCH] staging: et131x: remove unneccessary 'out of memory' message
Date: Tue, 30 Sep 2014 22:49:47 +0530
Message-Id: <1412097587-2779-1-git-send-email-karthik.188@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the 'out of memory' warning issues by checkpatch

Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
---
 drivers/staging/et131x/et131x.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 41fcaa0..f1a9296 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -2423,7 +2423,6 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 
 	skb = dev_alloc_skb(rfd->len + 2);
 	if (!skb) {
-		dev_err(&adapter->pdev->dev, "Couldn't alloc an SKB for Rx\n");
 		return NULL;
 	}
 
-- 
2.1.0

