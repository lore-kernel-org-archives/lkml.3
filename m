Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbaEaLz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 07:55:28 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48772 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbaEaLz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 07:55:27 -0400
From: Scott Weir <sjw0410@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: gdm724x: Added blank lines after declarations in gdm_lte.c
Date: Sat, 31 May 2014 21:54:58 +1000
Message-Id: <1401537298-13920-1-git-send-email-sjw0410@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following checkpatch.pl warning:
WARNING: Missing a blank line after declarations in gdm_lte.c

Signed-off-by: Scott Weir <sjw0410@gmail.com>
---
 drivers/staging/gdm724x/gdm_lte.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index 64c55b9..bc6d574 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -447,6 +447,7 @@ static int gdm_lte_tx(struct sk_buff *skb, struct net_device *dev)
 	 */
 	if (nic_type & NIC_TYPE_F_VLAN) {
 		struct vlan_ethhdr *vlan_eth = (struct vlan_ethhdr *)skb->data;
+
 		nic->vlan_id = ntohs(vlan_eth->h_vlan_TCI) & VLAN_VID_MASK;
 		data_buf = skb->data + (VLAN_ETH_HLEN - ETH_HLEN);
 		data_len = skb->len - (VLAN_ETH_HLEN - ETH_HLEN);
@@ -505,6 +506,7 @@ static int gdm_lte_tx(struct sk_buff *skb, struct net_device *dev)
 static struct net_device_stats *gdm_lte_stats(struct net_device *dev)
 {
 	struct nic *nic = netdev_priv(dev);
+
 	return &nic->stats;
 }

--
1.9.1

