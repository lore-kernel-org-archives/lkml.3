Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936438AbaICXxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:53:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215AbaICWFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:05:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick Riphagen <patrick.riphagen@xsens.com>,
        Frans Klaver <frans.klaver@xsens.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 06/55] USB: serial: ftdi_sio: Annotate the current Xsens PID assignments
Date: Wed,  3 Sep 2014 15:04:56 -0700
Message-Id: <20140903220454.647870101@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Riphagen <patrick.riphagen@xsens.com>

commit 9273b8a270878906540349422ab24558b9d65716 upstream.

The converters are used in specific products. It can be useful to know
which they are exactly.

Signed-off-by: Patrick Riphagen <patrick.riphagen@xsens.com>
Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio_ids.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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
 


