Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbbA0Puo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:50:44 -0500
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:57547 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbbA0Pul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:50:41 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] staging: comedi: comedi_compat.c: reformat copyright comment
Date: Tue, 27 Jan 2015 15:50:20 +0000
Message-Id: <1422373824-12793-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
References: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the usual block comment style.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_compat32.c | 38 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/comedi_compat32.c b/drivers/staging/comedi/comedi_compat32.c
index 2440c60..9364f08 100644
--- a/drivers/staging/comedi/comedi_compat32.c
+++ b/drivers/staging/comedi/comedi_compat32.c
@@ -1,23 +1,23 @@
 /*
-    comedi/comedi_compat32.c
-    32-bit ioctl compatibility for 64-bit comedi kernel module.
-
-    Author: Ian Abbott, MEV Ltd. <abbotti@mev.co.uk>
-    Copyright (C) 2007 MEV Ltd. <http://www.mev.co.uk/>
-
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 1997-2007 David A. Schleef <ds@schleef.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-*/
+ * comedi/comedi_compat32.c
+ * 32-bit ioctl compatibility for 64-bit comedi kernel module.
+ *
+ * Author: Ian Abbott, MEV Ltd. <abbotti@mev.co.uk>
+ * Copyright (C) 2007 MEV Ltd. <http://www.mev.co.uk/>
+ *
+ * COMEDI - Linux Control and Measurement Device Interface
+ * Copyright (C) 1997-2007 David A. Schleef <ds@schleef.org>
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
 
 #include <linux/uaccess.h>
 #include <linux/compat.h>
-- 
2.1.4

