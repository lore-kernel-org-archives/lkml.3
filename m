Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab3J1RdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:33:25 -0400
Received: from mout.gmx.net ([212.227.17.21]:53529 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353Ab3J1RdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:33:23 -0400
From: =?UTF-8?q?Michael=20Dr=C3=BCing?= <michael@drueing.de>
To: davem@davemloft.net
Cc: andrew.hendry@gmail.com, linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Michael=20Dr=C3=BCing?= <michael@drueing.de>
Subject: [PATCH] net: x25: Fix dead URLs in Kconfig
Date: Mon, 28 Oct 2013 18:33:12 +0100
Message-Id: <1382981592-7449-1-git-send-email-michael@drueing.de>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:U79wRLShDuvgwHNZTlOZaqDAvzHc8n+zr/IChh0+p2gSWs7rMLj
 rmT/KqRb1E2rJzkG6RL4B7X7kiKNkxd2Uce5+gVXf+pajLCo0m5yFex5iLycYNq8ueVUuqF
 DMgftOk3Kvuphbomzp11U26ePba+Z82Zgxg1vR34dzUeGIxiB6K4KcBq+DJL5D3pXIc/X4S
 7sbCDa3tX3rmiAGqnkrwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the URLs in the Kconfig file to the new pages at sangoma.com and cisco.com

Signed-off-by: Michael Drüing <michael@drueing.de>
---
 net/x25/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/x25/Kconfig b/net/x25/Kconfig
index c959312c..e2fa133 100644
--- a/net/x25/Kconfig
+++ b/net/x25/Kconfig
@@ -16,8 +16,8 @@ config X25
 	  if you want that) and the lower level data link layer protocol LAPB
 	  (say Y to "LAPB Data Link Driver" below if you want that).
 
-	  You can read more about X.25 at <http://www.sangoma.com/x25.htm> and
-	  <http://www.cisco.com/univercd/cc/td/doc/product/software/ios11/cbook/cx25.htm>.
+	  You can read more about X.25 at <http://www.sangoma.com/tutorials/x25/> and
+	  <http://docwiki.cisco.com/wiki/X.25>.
 	  Information about X.25 for Linux is contained in the files
 	  <file:Documentation/networking/x25.txt> and
 	  <file:Documentation/networking/x25-iface.txt>.
-- 
1.8.3.1

