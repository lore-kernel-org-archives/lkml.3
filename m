Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaH3SPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 14:15:11 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33302 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaH3SPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 14:15:09 -0400
From: Andrew Plummer <plummer574@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrew Plummer <plummer574@gmail.com>
Subject: [PATCH] Staging: nokia_h4p: nokia_fw: remove extra return
Date: Sat, 30 Aug 2014 19:14:51 +0100
Message-Id: <1409422491-6325-1-git-send-email-plummer574@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove empty return at end of function.

Signed-off-by: Andrew Plummer <plummer574@gmail.com>
---
 drivers/staging/nokia_h4p/nokia_fw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/nokia_h4p/nokia_fw.c b/drivers/staging/nokia_h4p/nokia_fw.c
index 14ba219..18953ae 100644
--- a/drivers/staging/nokia_h4p/nokia_fw.c
+++ b/drivers/staging/nokia_h4p/nokia_fw.c
@@ -197,8 +197,6 @@ void hci_h4p_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
 		dev_err(info->dev, "Don't know how to parse fw event\n");
 		info->fw_error = -EINVAL;
 	}
-
-	return;
 }
 
 MODULE_FIRMWARE(FW_NAME_TI1271_PRELE);
-- 
1.9.1

