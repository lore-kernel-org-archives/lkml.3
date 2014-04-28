Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbaD1Plc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:41:32 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43831 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaD1Pl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:41:29 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] net: bonding: Fix format string mismatch in bond_sysfs.c
Date: Tue, 29 Apr 2014 00:41:21 +0900
Message-Id: <1398699681-27339-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix format string mismatch in bonding_show_min_links().

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/bonding/bond_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 431892f..cb95ee4 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -534,7 +534,7 @@ static ssize_t bonding_show_min_links(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.min_links);
+	return sprintf(buf, "%u\n", bond->params.min_links);
 }
 
 static ssize_t bonding_store_min_links(struct device *d,
-- 
2.0.0.rc1

