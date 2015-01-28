Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588AbbA2CWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:22:14 -0500
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:58955 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758931AbbA2BwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:06 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] staging: comedi: range.c: reformat copyright comment
Date: Wed, 28 Jan 2015 18:41:49 +0000
Message-Id: <1422470510-9309-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
References: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the usual block comment style.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/range.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/range.c b/drivers/staging/comedi/range.c
index 00e71c7..6a393b2 100644
--- a/drivers/staging/comedi/range.c
+++ b/drivers/staging/comedi/range.c
@@ -1,20 +1,20 @@
 /*
-    module/range.c
-    comedi routines for voltage ranges
-
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 1997-8 David A. Schleef <ds@schleef.org>
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
+ * comedi/range.c
+ * comedi routines for voltage ranges
+ *
+ * COMEDI - Linux Control and Measurement Device Interface
+ * Copyright (C) 1997-8 David A. Schleef <ds@schleef.org>
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
 #include "comedidev.h"
-- 
2.1.4

