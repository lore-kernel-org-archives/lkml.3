Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaCXOEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:04:13 -0400
Received: from zproxy110.enst.fr ([137.194.52.33]:52845 "EHLO
	zproxy110.enst.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbaCXOEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:04:12 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Mar 2014 10:04:11 EDT
From: ioana.ileana@telecom-paristech.fr
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, joe@perches.com,
        teobaluta@gmail.com, forest@alittletooquiet.net,
        Ioana Ileana <ioana.ileana@telecom-paristech.fr>
Subject: [PATCH] staging: vt6655: fix sparse warning
Date: Mon, 24 Mar 2014 14:58:05 +0100
Message-Id: <1395669485-703-1-git-send-email-ioana.ileana@telecom-paristech.fr>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ioana Ileana <ioana.ileana@telecom-paristech.fr>

Added missing static qualifier

Signed-off-by: Ioana Ileana <ioana.ileana@telecom-paristech.fr>
---
 drivers/staging/vt6655/datarate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/datarate.c b/drivers/staging/vt6655/datarate.c
index c9a89cd..2d760da 100644
--- a/drivers/staging/vt6655/datarate.c
+++ b/drivers/staging/vt6655/datarate.c
@@ -51,7 +51,7 @@ extern unsigned short TxRate_iwconfig; //2008-5-8 <add> by chester
 /*---------------------  Static Variables  --------------------------*/
 //static int          msglevel                =MSG_LEVEL_DEBUG;
 static int msglevel = MSG_LEVEL_INFO;
-const unsigned char acbyIERate[MAX_RATE] =
+static const unsigned char acbyIERate[MAX_RATE] =
 {0x02, 0x04, 0x0B, 0x16, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
 
 #define AUTORATE_TXOK_CNT       0x0400
-- 
1.7.9.5

