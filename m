Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3A3BiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:38:06 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1084 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab3A3Bh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:37:57 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Michael Chan" <mchan@broadcom.com>
To: gregkh@linuxfoundation.org
cc: alexander.shishkin@linux.intel.com, shurd@broadcom.com,
        linux-kernel@vger.kernel.org, mchan@broadcom.com
Subject: [PATCH] serial_core: Fix type definition for
 PORT_BRCM_TRUMANAGE.
Date: Tue, 29 Jan 2013 17:54:44 -0800
Message-ID: <1359510884-8945-1-git-send-email-mchan@broadcom.com>
X-Mailer: git-send-email 1.5.5.GIT
MIME-Version: 1.0
X-WSS-ID: 7D16A7A23OO20294-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was mistakenly defined to be 24 instead of the next higher number 25.

Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Stephen Hurd <shurd@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
---
 include/uapi/linux/serial_core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
index 08464ef..b6a23a4 100644
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@ -50,7 +50,7 @@
 #define PORT_LPC3220	22	/* NXP LPC32xx SoC "Standard" UART */
 #define PORT_8250_CIR	23	/* CIR infrared port, has its own driver */
 #define PORT_XR17V35X	24	/* Exar XR17V35x UARTs */
-#define PORT_BRCM_TRUMANAGE	24
+#define PORT_BRCM_TRUMANAGE	25
 #define PORT_MAX_8250	25	/* max port ID */
 
 /*
-- 
1.7.1


