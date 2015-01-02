Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbbABQIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 11:08:14 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62855 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbABQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 11:08:13 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pankaj.saraf@nektech.in, jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH] Staging: comedi: tab space coding style issue in pcl818.c
Date: Fri,  2 Jan 2015 21:37:44 +0530
Message-Id: <1420214864-14793-1-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch to the pcl818.c that fix up a use tab error
found by the checkpatch.pl tool
---
 drivers/staging/comedi/drivers/pcl818.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 8edea35..c29223b 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -45,7 +45,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA	(0=disable, 1, 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+		1= 1MHz clock for 8254
     [4] - 0,  5=A/D input  -5V.. +5V
           1, 10=A/D input -10V..+10V
     [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
-- 
1.9.1

