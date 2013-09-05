Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3IERck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:32:40 -0400
Received: from mail-pa0-f67.google.com ([209.85.220.67]:62642 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3IERci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:32:38 -0400
From: Avinash Kumar <avi.kp.137@gmail.com>
To: gregkh@linuxfoundation.org
Cc: klmckinney1@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Avinash Kumar <avi.kp.137@gmail.com>
Subject: [PATCH] staging: bcm: InterfaceMisc.c: fixed styling issue in casting (foo*)->(foo *)
Date: Thu,  5 Sep 2013 23:02:16 +0530
Message-Id: <1378402336-12351-1-git-send-email-avi.kp.137@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed styling issue in pointer typecast.

Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>
---
 drivers/staging/bcm/InterfaceMisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/InterfaceMisc.c b/drivers/staging/bcm/InterfaceMisc.c
index afca010..d9fa2bb 100644
--- a/drivers/staging/bcm/InterfaceMisc.c
+++ b/drivers/staging/bcm/InterfaceMisc.c
@@ -104,7 +104,7 @@ int BcmRDM(void *arg,
 	void *buff,
 	int len)
 {
-	return InterfaceRDM((struct bcm_interface_adapter*)arg, addr, buff, len);
+	return InterfaceRDM((struct bcm_interface_adapter *)arg, addr, buff, len);
 }
 
 int BcmWRM(void *arg,
-- 
1.7.10.4

