Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaGQEDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 00:03:33 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63630 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaGQEDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 00:03:31 -0400
From: Kiran Padwal <kiran.padwal21@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rashika.kheria@gmail.com, rusty@rustcorp.com.au,
        valentina.manea.m@gmail.com, gulsah.1004@gmail.com, wkang77@gmail.com,
        kiran.padwal21@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: gdm724x: gdm_lte.c: fix missing blank line after variable declaration
Date: Thu, 17 Jul 2014 09:30:38 +0530
Message-Id: <1405569638-9435-1-git-send-email-kiran.padwal21@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch fix - Add missing blank line after variable declaration

Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
---
 drivers/staging/gdm724x/gdm_lte.c |    2 ++
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
1.7.9.5

