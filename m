Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010AbaE3Qot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:44:49 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46472 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964962AbaE3Qor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:44:47 -0400
From: Miguel Oliveira <cmroliv@gmail.com>
To: gregkh@linuxfoundation.org
Cc: gulsah.1004@gmail.com, pavel@ucw.cz, pali.rohar@gmail.com,
        cmroliv@gmail.com, kristina.martsenko@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: nokia_h4: nokia_core.c Fixed coding style
Date: Fri, 30 May 2014 17:44:26 +0100
Message-Id: <1401468266-3481-1-git-send-email-cmroliv@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inserted a blank line after a declaration.

Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
---
 drivers/staging/nokia_h4p/nokia_core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/nokia_h4p/nokia_core.c b/drivers/staging/nokia_h4p/nokia_core.c
index 5e19cd6..775e1d0 100644
--- a/drivers/staging/nokia_h4p/nokia_core.c
+++ b/drivers/staging/nokia_h4p/nokia_core.c
@@ -756,6 +756,7 @@ static int hci_h4p_reset(struct hci_h4p_info *info)
 static int hci_h4p_hci_flush(struct hci_dev *hdev)
 {
 	struct hci_h4p_info *info = hci_get_drvdata(hdev);
+
 	skb_queue_purge(&info->txq);
 
 	return 0;
--
1.7.10.4

