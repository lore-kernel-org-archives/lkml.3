Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaICJ4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:56:18 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57354 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756168AbaICJ4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:56:15 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Patrick Riphagen <patrick.riphagen@xsens.com>,
        Frans Klaver <frans.klaver@xsens.com>, Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 17/56] USB: serial: ftdi_sio: Annotate the current Xsens PID assignments
Date: Wed,  3 Sep 2014 11:26:36 +0200
Message-Id: <b84c4c6eb4da51303ce7d0ffd50e495b2a07f735.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Riphagen <patrick.riphagen@xsens.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9273b8a270878906540349422ab24558b9d65716 upstream.

The converters are used in specific products. It can be useful to know
which they are exactly.

Signed-off-by: Patrick Riphagen <patrick.riphagen@xsens.com>
Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/ftdi_sio_ids.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index c4777bc6aee0..3fc789701e45 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -140,12 +140,12 @@
 /*
  * Xsens Technologies BV products (http://www.xsens.com).
  */
-#define XSENS_CONVERTER_0_PID	0xD388
-#define XSENS_CONVERTER_1_PID	0xD389
+#define XSENS_CONVERTER_0_PID	0xD388	/* Xsens USB converter */
+#define XSENS_CONVERTER_1_PID	0xD389	/* Xsens Wireless Receiver */
 #define XSENS_CONVERTER_2_PID	0xD38A
-#define XSENS_CONVERTER_3_PID	0xD38B
-#define XSENS_CONVERTER_4_PID	0xD38C
-#define XSENS_CONVERTER_5_PID	0xD38D
+#define XSENS_CONVERTER_3_PID	0xD38B	/* Xsens USB-serial converter */
+#define XSENS_CONVERTER_4_PID	0xD38C	/* Xsens Wireless Receiver */
+#define XSENS_CONVERTER_5_PID	0xD38D	/* Xsens Awinda Station */
 #define XSENS_CONVERTER_6_PID	0xD38E
 #define XSENS_CONVERTER_7_PID	0xD38F
 
-- 
2.1.0

