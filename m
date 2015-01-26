Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbbAZN0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:26:01 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:54307 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291AbbAZNZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:25:45 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] staging: comedi: 8255.h: reformat copyright comment
Date: Mon, 26 Jan 2015 13:25:25 +0000
Message-Id: <1422278725-17740-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422278725-17740-1-git-send-email-abbotti@mev.co.uk>
References: <1422278725-17740-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the usual block comment style.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/8255.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.h b/drivers/staging/comedi/drivers/8255.h
index 5985c8e..934b940 100644
--- a/drivers/staging/comedi/drivers/8255.h
+++ b/drivers/staging/comedi/drivers/8255.h
@@ -1,20 +1,20 @@
 /*
-    module/8255.h
-    Header file for 8255
-
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 1998 David A. Schleef <ds@schleef.org>
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
+ * module/8255.h
+ * Header file for 8255
+ *
+ * COMEDI - Linux Control and Measurement Device Interface
+ * Copyright (C) 1998 David A. Schleef <ds@schleef.org>
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
 
 #ifndef _8255_H
 #define _8255_H
-- 
2.1.4

