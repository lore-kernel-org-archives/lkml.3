Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030408AbaDBVAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 17:00:44 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51048 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbaDBVAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 17:00:43 -0400
From: code@slynux.com
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sarath Lakshman <sarathlakshman@slynux.com>
Subject: [PATCH] staging: nokia_h4p: Fix a coding style problem
Date: Thu,  3 Apr 2014 02:30:18 +0530
Message-Id: <1396472418-8711-1-git-send-email-code@slynux.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarath Lakshman <sarathlakshman@slynux.com>

Fold a line to make it less than 80 characters

Signed-off-by: Sarath Lakshman <sarathlakshman@slynux.com>
---
 drivers/staging/nokia_h4p/nokia_fw-bcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/nokia_h4p/nokia_fw-bcm.c b/drivers/staging/nokia_h4p/nokia_fw-bcm.c
index 111ae94..b55f5ba 100644
--- a/drivers/staging/nokia_h4p/nokia_fw-bcm.c
+++ b/drivers/staging/nokia_h4p/nokia_fw-bcm.c
@@ -73,7 +73,8 @@ void hci_h4p_bcm_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
 		return;
 	}
 
-	if (fw_skb->data[1] == 0x01 && fw_skb->data[2] == 0xfc && fw_skb->len >= 10) {
+	if (fw_skb->data[1] == 0x01 && fw_skb->data[2] == 0xfc &&
+			fw_skb->len >= 10) {
 		BT_DBG("Setting bluetooth address");
 		err = hci_h4p_bcm_set_bdaddr(info, fw_skb);
 		if (err < 0) {
-- 
1.8.3.2

