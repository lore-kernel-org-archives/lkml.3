Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaIDPLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:11:36 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47210 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaIDPLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:11:35 -0400
From: Chaitra Ramaiah <linux.delve@gmail.com>
To: gregkh@linuxfoundation.org, burzalodowa@gmail.com, anarey@gmail.com,
        rmfrfs@gmail.com, gdonald@gmail.com, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitra Ramaiah <linux.delve@gmail.com>
Subject: [PATCH] Staging: rtl8192u: fix brace style coding issue in r819xU_firmware.c 
Date: Thu,  4 Sep 2014 20:41:03 +0530
Message-Id: <1409843463-3702-2-git-send-email-linux.delve@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409843463-3702-1-git-send-email-linux.delve@gmail.com>
References: <1409843463-3702-1-git-send-email-linux.delve@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chaitra Ramaiah <linux.delve@gmail.com>
---
 drivers/staging/rtl8192u/r819xU_firmware.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
index 671cbe6..40e1ef5 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -153,11 +153,10 @@ static bool CPUcheck_maincodeok_turnonCPU(struct net_device *dev)
 			break;
 	}while(check_bootOk_time--);
 
-	if (!(CPU_status&CPU_GEN_BOOT_RDY)) {
+	if (!(CPU_status&CPU_GEN_BOOT_RDY))
 		goto CPUCheckMainCodeOKAndTurnOnCPU_Fail;
-	} else {
+	else
 		RT_TRACE(COMP_FIRMWARE, "Download Firmware: Boot ready!\n");
-	}
 
 	return rt_status;
 
-- 
1.7.9.5

