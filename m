Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaGNRVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:21:51 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38364 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaGNRVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:21:41 -0400
From: Rahul Bedarkar <rahulbedarkar89@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rahul Bedarkar <rahulbedarkar89@gmail.com>
Subject: [PATCH] staging: octeon: fix coding style
Date: Mon, 14 Jul 2014 22:51:15 +0530
Message-Id: <1405358475-3806-1-git-send-email-rahulbedarkar89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes checkpatch.pl warning. Add blank line after
declaration.

Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>
---
 drivers/staging/octeon/ethernet-xaui.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/octeon/ethernet-xaui.c b/drivers/staging/octeon/ethernet-xaui.c
index 419f8c3..a093dfb 100644
--- a/drivers/staging/octeon/ethernet-xaui.c
+++ b/drivers/staging/octeon/ethernet-xaui.c
@@ -111,6 +111,7 @@ static void cvm_oct_xaui_poll(struct net_device *dev)
 int cvm_oct_xaui_init(struct net_device *dev)
 {
 	struct octeon_ethernet *priv = netdev_priv(dev);
+
 	cvm_oct_common_init(dev);
 	dev->netdev_ops->ndo_stop(dev);
 	if (!octeon_is_simulation() && priv->phydev == NULL)
-- 
1.8.3.2

