Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaLOP0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:26:15 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44278 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaLOP0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:26:13 -0500
From: Karthik Nayak <karthik.188@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Larry.Finger@lwfinger.net, Karthik Nayak <karthik.188@gmail.com>
Subject: [PATCH] Staging: rtl8712: removed an unnecessary else statement
Date: Mon, 15 Dec 2014 20:55:54 +0530
Message-Id: <1418657154-10481-1-git-send-email-karthik.188@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per checkpatch warning, removed an unnecessary else statement
proceeding an if statement with a return.

Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
---
 drivers/staging/rtl8712/rtl8712_recv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index cd8b444..800b2b3 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -496,8 +496,7 @@ static int enqueue_reorder_recvframe(struct recv_reorder_ctrl *preorder_ctrl,
 			plist = plist->next;
 		else if (SN_EQUAL(pnextattrib->seq_num, pattrib->seq_num))
 			return false;
-		else
-			break;
+		break;
 	}
 	list_del_init(&(prframe->u.hdr.list));
 	list_add_tail(&(prframe->u.hdr.list), plist);
-- 
2.1.3

