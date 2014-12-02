Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaLBRfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:35:50 -0500
Received: from mail.1ago.be ([178.18.131.20]:55671 "EHLO mail.1ago.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbaLBRfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:35:48 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 12:35:48 EST
From: Pieter Waegeman <pieter@1ago.be>
To: klmckinney1@gmail.com, mail@beyermatthias.de
Cc: gregkh@linuxfoundation.org, tapaswenipathak@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pieter Waegeman <pieter@1ago.be>
Subject: [PATCH] Staging: bcm: Fix tab between spaces in InterfaceMacros.h This is a patch to the InterfaceMacros.h file that fixes an added tab instead of a space. Found by the checkpatch.pl tool.
Date: Tue,  2 Dec 2014 18:25:49 +0100
Message-Id: <1417541149-18697-1-git-send-email-pieter@1ago.be>
X-Mailer: git-send-email 2.1.0
Signed-off-by: Pieter Waegeman <pieter@1ago.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/bcm/InterfaceMacros.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/InterfaceMacros.h b/drivers/staging/bcm/InterfaceMacros.h
index fedb794..67e7b62 100644
--- a/drivers/staging/bcm/InterfaceMacros.h
+++ b/drivers/staging/bcm/InterfaceMacros.h
@@ -4,7 +4,7 @@
 #define BCM_USB_MAX_READ_LENGTH 2048
 
 #define MAXIMUM_USB_TCB      128
-#define MAXIMUM_USB_RCB 	 128
+#define MAXIMUM_USB_RCB	     128
 
 #define MAX_BUFFERS_PER_QUEUE   256
 
-- 
2.1.0

