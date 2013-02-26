Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167Ab3B0BSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:18:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997Ab3BZX5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Stephen Hurd <shurd@broadcom.com>, Michael Chan <mchan@broadcom.com>
Subject: [ 019/150] serial_core: Fix type definition for PORT_BRCM_TRUMANAGE.
Date: Tue, 26 Feb 2013 15:54:36 -0800
Message-Id: <20130226235526.246172467@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit 85f024401bf80746ae08b7fd5809a9b16accf0b1 upstream.

It was mistakenly defined to be 24 instead of the next higher number 25.

Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Stephen Hurd <shurd@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/serial_core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


