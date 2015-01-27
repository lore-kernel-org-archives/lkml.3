Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbbA0Rt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:49:26 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:46525 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758473AbbA0RtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:49:24 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/9] staging: comedi: add comedi_usb.h
Date: Tue, 27 Jan 2015 17:49:01 +0000
Message-Id: <1422380949-5994-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422380949-5994-1-git-send-email-abbotti@mev.co.uk>
References: <1422380949-5994-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new header that Comedi USB drivers can include instead of
"comedidev.h".  Currently, it just pulls in <linux/usb.h> and
"comedidev.h", but the plan is to migrate the USB-specific stuff from
"comedidev.h" here.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_usb.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 drivers/staging/comedi/comedi_usb.h

diff --git a/drivers/staging/comedi/comedi_usb.h b/drivers/staging/comedi/comedi_usb.h
new file mode 100644
index 0000000..a57025b
--- /dev/null
+++ b/drivers/staging/comedi/comedi_usb.h
@@ -0,0 +1,30 @@
+/*
+ * comedi_usb.h
+ * header file for USB Comedi drivers
+ *
+ * COMEDI - Linux Control and Measurement Device Interface
+ * Copyright (C) 1997-2000 David A. Schleef <ds@schleef.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _COMEDI_USB_H
+#define _COMEDI_USB_H
+
+#include <linux/usb.h>
+
+#include "comedidev.h"
+
+/*
+ * TODO: Move USB-specific stuff into here from "comedidev.h".
+ */
+
+#endif /* _COMEDI_USB_H */
-- 
2.1.4

