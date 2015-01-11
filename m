Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbbAKOs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 09:48:59 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61626 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbbAKOs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 09:48:58 -0500
From: Sakshi Bansal <sakshi.april5@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, tvboxspy@gmail.com, gclement@baobob.org,
        guido@vanguardiasur.com.ar, shack@linux.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sakshi Bansal <sakshi.april5@gmail.com>
Subject: [PATCH v3] Staging: vt6655: fixed a coding style warning
Date: Sun, 11 Jan 2015 20:18:44 +0530
Message-Id: <1420987724-7184-1-git-send-email-sakshi.april5@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed 80 line warning in the code comments.

Signed-off-by: Sakshi Bansal <sakshi.april5@gmail.com>
---
Changes in v3:
  - Make the commit message more clearer.

 drivers/staging/vt6655/baseband.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 86c72ba..c138f9b 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -27,7 +27,8 @@
  *
  * Functions:
  *      BBuGetFrameTime        - Calculate data frame transmitting time
- *      BBvCaculateParameter   - Caculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
+ *      BBvCaculateParameter   - Caculate PhyLength, PhyService and Phy Signal
+ *                               parameter for baseband Tx
  *      BBbReadEmbedded         - Embedded read baseband register via MAC
  *      BBbWriteEmbedded        - Embedded write baseband register via MAC
  *      BBbVT3253Init          - VIA VT3253 baseband chip init code
-- 
1.9.1

