Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbbABQQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 11:16:07 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35543 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbbABQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 11:16:06 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pankaj.saraf@nektech.in, jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: fix tab style issue
Date: Fri,  2 Jan 2015 21:45:43 +0530
Message-Id: <1420215343-15006-1-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to pcl818 that fix tab style error which is
found by the checkpatch tool

Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index c29223b..aa93d55 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -47,7 +47,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
     [3] - 0, 10=10MHz clock for 8254
 		1= 1MHz clock for 8254
     [4] - 0,  5=A/D input  -5V.. +5V
-          1, 10=A/D input -10V..+10V
+		1, 10=A/D input -10V..+10V
     [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
           1, 10=D/A output 0-10V (internal reference -10V)
 	  2    =D/A output unknown (external reference)
-- 
1.9.1

