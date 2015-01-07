Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbbAGRHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:07:47 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32890 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbbAGRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:07:44 -0500
From: sakshi <sakshi.april5@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, tvboxspy@gmail.com, gclement@baobob.org,
        guido@vanguardiasur.com.ar, shack@linux.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        sakshi <sakshi.april5@gmail.com>
Subject: [PATCH] Fixed line over 80 characters warning
Date: Wed,  7 Jan 2015 22:37:26 +0530
Message-Id: <1420650446-21507-1-git-send-email-sakshi.april5@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: sakshi <sakshi.april5@gmail.com>
---
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

