Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbbAKTmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 14:42:51 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:51716 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbAKTms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 14:42:48 -0500
From: David Decotigny <ddecotig@gmail.com>
To: Ariel Elior <ariel.elior@qlogic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: David Decotigny <decot@googlers.com>
Subject: [PATCH net-next v1] net: bnx2x: avoid macro redefinition
Date: Sun, 11 Jan 2015 11:42:37 -0800
Message-Id: <1421005357-25708-1-git-send-email-ddecotig@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>

Signed-off-by: David Decotigny <decot@googlers.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index 792ba72..756053c 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1138,12 +1138,8 @@ struct bnx2x_port {
 	u32			link_config[LINK_CONFIG_SIZE];
 
 	u32			supported[LINK_CONFIG_SIZE];
-/* link settings - missing defines */
-#define SUPPORTED_2500baseX_Full	(1 << 15)
 
 	u32			advertising[LINK_CONFIG_SIZE];
-/* link settings - missing defines */
-#define ADVERTISED_2500baseX_Full	(1 << 15)
 
 	u32			phy_addr;
 
-- 
2.2.0.rc0.207.ga3a616c

