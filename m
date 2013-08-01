Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab3HATf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:35:56 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:21427 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797Ab3HATfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:35:53 -0400
Message-ID: <0415298704a27a9b52ec5e82e8d7d0ed72febb0d.1375385120.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375385119.git.cmetcalf@tilera.com>
References: <20130801.113100.2059303096028571906.davem@davemloft.net>
	<cover.1375385119.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 1 Aug 2013 11:36:42 -0400
Subject: [PATCH v3 12/13] tile: remove deprecated NETIF_F_LLTX flag from tile drivers
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/net/ethernet/tile/tilegx.c  | 1 -
 drivers/net/ethernet/tile/tilepro.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index 7302e84..0beed7e 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -1963,7 +1963,6 @@ static void tile_net_setup(struct net_device *dev)
 	dev->watchdog_timeo = TILE_NET_TIMEOUT;
 	dev->mtu = 1500;
 
-	features |= NETIF_F_LLTX;
 	features |= NETIF_F_HW_CSUM;
 	features |= NETIF_F_SG;
 	features |= NETIF_F_TSO;
diff --git a/drivers/net/ethernet/tile/tilepro.c b/drivers/net/ethernet/tile/tilepro.c
index fd17af5..106be47 100644
--- a/drivers/net/ethernet/tile/tilepro.c
+++ b/drivers/net/ethernet/tile/tilepro.c
@@ -2253,7 +2253,6 @@ static void tile_net_setup(struct net_device *dev)
 	dev->tx_queue_len = TILE_NET_TX_QUEUE_LEN;
 	dev->mtu = TILE_NET_MTU;
 
-	features |= NETIF_F_LLTX;
 	features |= NETIF_F_HW_CSUM;
 	features |= NETIF_F_SG;
 
-- 
1.8.3.1

