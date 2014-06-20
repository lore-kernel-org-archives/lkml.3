Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbaFTP0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:26:12 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:65340 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbaFTP0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:26:10 -0400
From: rbasukala <basukalaramesh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        rbasukala <basukalaramesh@gmail.com>
Subject: [PATCH] fix coding style issue
Date: Fri, 20 Jun 2014 11:25:58 -0400
Message-Id: <1403277958-32684-1-git-send-email-basukalaramesh@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: rbasukala <basukalaramesh@gmail.com>
---
 drivers/staging/netlogic/xlr_net.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index e320d6b..3ad48a0 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -1105,6 +1105,7 @@ err_gmac:
 static int xlr_net_remove(struct platform_device *pdev)
 {
 	struct xlr_net_priv *priv = platform_get_drvdata(pdev);
+
 	unregister_netdev(priv->ndev);
 	mdiobus_unregister(priv->mii_bus);
 	mdiobus_free(priv->mii_bus);
-- 
1.7.1

