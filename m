Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaIKNL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:11:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbaIKNEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Patrick Riphagen" <patrick.riphagen@xsens.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Frans Klaver" <frans.klaver@xsens.com>,
        "Johan Hovold" <johan@kernel.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.844497303@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 045/131] USB: serial: ftdi_sio: Annotate the current
 Xsens PID assignments
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Riphagen <patrick.riphagen@xsens.com>

commit 9273b8a270878906540349422ab24558b9d65716 upstream.

The converters are used in specific products. It can be useful to know
which they are exactly.

Signed-off-by: Patrick Riphagen <patrick.riphagen@xsens.com>
Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio_ids.h | 10 +++++-----
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
 

