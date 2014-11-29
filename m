Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbaK2NfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 08:35:06 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35519 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaK2NfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 08:35:04 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, joe@perches.com, marek.belisko@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH]  staging:drivers:staging:ft1000:ft1000_pcmcia:ft1000_hw.c:Added a blank line after declaration
Date: Sat, 29 Nov 2014 19:04:33 +0530
Message-Id: <1417268073-7394-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl warning

WARNING: Missing a blank line after declaration

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 11dbe36..d5475b7 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -2042,6 +2042,7 @@ static void ft1000_get_drvinfo(struct net_device *dev,
 static u32 ft1000_get_link(struct net_device *dev)
 {
 	struct ft1000_info *info;
+
 	info = netdev_priv(dev);
 	return info->mediastate;
 }
-- 
1.9.1

