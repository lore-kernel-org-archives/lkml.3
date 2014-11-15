Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaKOPzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 10:55:41 -0500
Received: from mail-la0-f65.google.com ([209.85.215.65]:42365 "EHLO
	mail-la0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbaKOPzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 10:55:40 -0500
From: Marcus Hufvudsson <marcushuf@gmail.com>
To: abbotti@mev.co.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marcus Hufvudsson <marcushuf@gmail.com>
Subject: [PATCH] staging: comedi: me4000: Fixed code style issue
Date: Sat, 15 Nov 2014 16:55:20 +0100
Message-Id: <1416066920-10012-1-git-send-email-marcushuf@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch.pl error message. Space prohibited before that ','

Signed-off-by: Marcus Hufvudsson <marcushuf@gmail.com>
---
 drivers/staging/comedi/drivers/me4000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index ae6ac49..fc67419 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -416,7 +416,7 @@ static void me4000_reset(struct comedi_device *dev)
 	val |= PLX9052_CNTRL_PCI_RESET;
 	outl(val, info->plx_regbase + PLX9052_CNTRL);
 	val &= ~PLX9052_CNTRL_PCI_RESET;
-	outl(val , info->plx_regbase + PLX9052_CNTRL);
+	outl(val, info->plx_regbase + PLX9052_CNTRL);
 
 	/* 0x8000 to the DACs means an output voltage of 0V */
 	for (chan = 0; chan < 4; chan++)
-- 
1.7.10.4

