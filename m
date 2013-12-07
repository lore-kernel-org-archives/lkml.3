Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab3LGTUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 14:20:39 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38270 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab3LGTUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 14:20:35 -0500
From: Roman Kuznetsov <kuznetsov24@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Roman Kuznetsov <kuznetsov24@gmail.com>
Subject: [PATCH] ipc/mqueue.c: fixed a brace coding style issue
Date: Sat,  7 Dec 2013 23:20:26 +0400
Message-Id: <1386444026-14771-1-git-send-email-kuznetsov24@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Roman Kuznetsov <kuznetsov24@gmail.com>
---
 ipc/mqueue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 95827ce..9346238 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1303,11 +1303,10 @@ retry:
 out_fput:
 	fdput(f);
 out:
-	if (sock) {
+	if (sock)
 		netlink_detachskb(sock, nc);
-	} else if (nc) {
+	else if (nc)
 		dev_kfree_skb(nc);
-	}
 	return ret;
 }
 
-- 
1.8.1.2

