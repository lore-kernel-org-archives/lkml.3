Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab3IPQKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:10:04 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45304 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3IPQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:10:00 -0400
From: Avinash Kumar <avi.kp.137@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avinash Kumar <avi.kp.137@gmail.com>
Subject: [PATCH 4/4] drivers: net: phy: cicada.c: clears warning Use #include <linux/io.h> instead of <asm/io.h>
Date: Mon, 16 Sep 2013 21:39:41 +0530
Message-Id: <1379347781-7145-1-git-send-email-avi.kp.137@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clears following warnings :
WARNING: Use include <linux/io.h> instead of <asm/io.h>
WARNING: Use include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>
---
 drivers/net/phy/cicada.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/cicada.c b/drivers/net/phy/cicada.c
index db472ff..313a037 100644
--- a/drivers/net/phy/cicada.c
+++ b/drivers/net/phy/cicada.c
@@ -30,9 +30,9 @@
 #include <linux/ethtool.h>
 #include <linux/phy.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/irq.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /* Cicada Extended Control Register 1 */
 #define MII_CIS8201_EXT_CON1           0x17
-- 
1.7.10.4

