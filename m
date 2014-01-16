Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaAPGFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:05:52 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37817 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAPGFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:05:51 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mugunthan V N <mugunthanvnm@ti.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] net: davinci_mdio: Fix sparse warning
Date: Thu, 16 Jan 2014 11:35:41 +0530
Message-Id: <1389852341-15393-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch fixes following sparse warning
davinci_mdio.c:85:27: warning: symbol 'default_pdata' was not declared. Should it be static?
Also makes the default_pdata as a constant.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/net/ethernet/ti/davinci_mdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index 4ec9265..0cca9de 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -82,7 +82,7 @@ struct davinci_mdio_regs {
 	}	user[0];
 };
 
-struct mdio_platform_data default_pdata = {
+static const struct mdio_platform_data default_pdata = {
 	.bus_freq = DEF_OUT_FREQ,
 };
 
-- 
1.7.9.5

