Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaIXI4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:56:20 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39224 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaIXIz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:55:58 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, davem@davemloft.net, angus@agibson.me,
        tklauser@distanz.ch, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 4/4] staging: et131x: Remove unnecessary parentheses
Date: Wed, 24 Sep 2014 09:54:42 +0100
Message-Id: <1411548882-10639-4-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411548882-10639-1-git-send-email-mark.einon@gmail.com>
References: <1411506437.29268.13.camel@joe-AO725>
 <1411548882-10639-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index cd90831..0a927d2 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -2634,7 +2634,7 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 				desc[frag].len_vlan = skb_headlen(skb) / 2;
 				dma_addr = dma_map_single(&adapter->pdev->dev,
 							  skb->data,
-							  (skb_headlen(skb) / 2),
+							  skb_headlen(skb) / 2,
 							  DMA_TO_DEVICE);
 				desc[frag].addr_lo = lower_32_bits(dma_addr);
 				desc[frag].addr_hi = upper_32_bits(dma_addr);
@@ -2643,8 +2643,8 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 				desc[frag].len_vlan = skb_headlen(skb) / 2;
 				dma_addr = dma_map_single(&adapter->pdev->dev,
 							  skb->data +
-							  (skb_headlen(skb) / 2),
-							  (skb_headlen(skb) / 2),
+							  skb_headlen(skb) / 2,
+							  skb_headlen(skb) / 2,
 							  DMA_TO_DEVICE);
 				desc[frag].addr_lo = lower_32_bits(dma_addr);
 				desc[frag].addr_hi = upper_32_bits(dma_addr);
-- 
1.7.10.4

