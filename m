Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbbAKWSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:18:12 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:42663 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbAKWSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:18:10 -0500
From: "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] Staging: vt6655: Fixed a typo
Date: Sun, 11 Jan 2015 16:18:00 -0600
Message-Id: <1421014680-1415-1-git-send-email-silvagustavosilva@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a typo in mac.c file.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/staging/vt6655/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 8f0d652..1975c91 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -356,7 +356,7 @@ bool MACbSafeSoftwareReset(void __iomem *dwIoBase)
 
 /*
  * Description:
- *      Trun Off MAC Rx
+ *      Turn Off MAC Rx
  *
  * Parameters:
  *  In:
@@ -417,7 +417,7 @@ bool MACbSafeRxOff(void __iomem *dwIoBase)
 
 /*
  * Description:
- *      Trun Off MAC Tx
+ *      Turn Off MAC Tx
  *
  * Parameters:
  *  In:
-- 
1.9.1

