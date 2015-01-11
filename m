Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbbAKWqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:46:55 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:65371 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbbAKWqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:46:54 -0500
From: "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] Staging: vt6656: Fixed typo in a variable name
Date: Sun, 11 Jan 2015 16:46:45 -0600
Message-Id: <1421016405-5142-1-git-send-email-silvagustavosilva@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed typo in a variable name in dpc.h file.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/staging/vt6656/dpc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/dpc.h b/drivers/staging/vt6656/dpc.h
index fab195f..95e0e83 100644
--- a/drivers/staging/vt6656/dpc.h
+++ b/drivers/staging/vt6656/dpc.h
@@ -32,6 +32,6 @@
 #include "device.h"
 
 int vnt_rx_data(struct vnt_private *, struct vnt_rcb *,
-	unsigned long bytes_recieved);
+	unsigned long bytes_received);
 
 #endif /* __RXTX_H__ */
-- 
1.9.1

