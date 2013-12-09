Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3LIHY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:24:29 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47041 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3LIHY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:24:27 -0500
Message-ID: <1386573859.5508.0.camel@phoenix>
Subject: [PATCH] regulator: pfuze100: Fix address of FABID
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 09 Dec 2013 15:24:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet, the address of FABID is 0x4. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/pfuze100-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 032df37..8b5e4c7 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -38,7 +38,7 @@
 
 #define PFUZE100_DEVICEID	0x0
 #define PFUZE100_REVID		0x3
-#define PFUZE100_FABID		0x3
+#define PFUZE100_FABID		0x4
 
 #define PFUZE100_SW1ABVOL	0x20
 #define PFUZE100_SW1CVOL	0x2e
-- 
1.8.1.2



