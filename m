Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934640AbbA1EtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:49:23 -0500
Received: from mail.kernel.org ([198.145.29.136]:40027 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933845AbbA1EWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:22:37 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Patrick Riphagen <patrick.riphagen@xsens.com>,
        Frans Klaver <frans.klaver@xsens.com>, Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 094/177] USB: serial: ftdi_sio: Annotate the current Xsens PID assignments
Date: Wed, 28 Jan 2015 12:09:12 +0800
Message-Id: <1422418236-12852-185-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Riphagen <patrick.riphagen@xsens.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 9273b8a270878906540349422ab24558b9d65716 upstream.

The converters are used in specific products. It can be useful to know
which they are exactly.

Signed-off-by: Patrick Riphagen <patrick.riphagen@xsens.com>
Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/ftdi_sio_ids.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 7628b91..61f0902 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -142,12 +142,12 @@
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
1.9.1

