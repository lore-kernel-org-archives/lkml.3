Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3LXRVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 12:21:49 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:57798 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3LXRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 12:21:48 -0500
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <niteshjain92@gmail.com>
X-Mailer: mail (GNU Mailutils 2.99.98)
Message-Id: <20131224172137.6088A124A93@ideabot>
Date: Tue, 24 Dec 2013 22:51:37 +0530 (IST)
From: Nitesh A Jain <niteshjain92@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitesh A Jain <niteshjain92@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Nitesh A Jain <niteshjain92@gmail.com>
Subject: [PATCH] Staging: bcm: Bcmchar.c: fixed a space before semicolon coding style issue
Date: Tue, 24 Dec 2013 22:51:14 +0530
Message-Id: <1387905674-27546-1-git-send-email-niteshjain92@gmail.com>
X-Mailer: git-send-email 1.8.5.1

Fixed a coding style issue

Signed-off-by: Nitesh A Jain <niteshjain92@gmail.com>
---
 drivers/staging/bcm/Bcmchar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 87b74ca..25f910b03 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1190,7 +1190,7 @@ cntrlEnd:
 		break;
 
 	case IOCTL_BCM_CAL_INIT: {
-		UINT uiSectorSize = 0 ;
+		UINT uiSectorSize = 0;
 		if (Adapter->eNVMType == NVM_FLASH) {
 			if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
 				return -EFAULT;
-- 
1.7.10.4

