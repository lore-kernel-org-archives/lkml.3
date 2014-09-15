Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaIOMqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:46:33 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34944 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbaIOMqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:46:30 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] staging: comedi: migrate copyrights from "comedi_fc.c"
Date: Mon, 15 Sep 2014 13:46:06 +0100
Message-Id: <1410785167-28506-11-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "comedi_fc" module was originally written and copyrighted by Frank
Mori Hess, but the functionality has been migrated into the core
"comedi" module.  Move the copyright notices over to the affected .c
files in the core comedi module.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_buf.c | 1 +
 drivers/staging/comedi/drivers.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/staging/comedi/comedi_buf.c b/drivers/staging/comedi/comedi_buf.c
index c3f5751..c60a45ad 100644
--- a/drivers/staging/comedi/comedi_buf.c
+++ b/drivers/staging/comedi/comedi_buf.c
@@ -3,6 +3,7 @@
  *
  * COMEDI - Linux Control and Measurement Device Interface
  * Copyright (C) 1997-2000 David A. Schleef <ds@schleef.org>
+ * Copyright (C) 2002 Frank Mori Hess <fmhess@users.sourceforge.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 3c7d865..3e5bccb 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -4,6 +4,7 @@
 
     COMEDI - Linux Control and Measurement Device Interface
     Copyright (C) 1997-2000 David A. Schleef <ds@schleef.org>
+    Copyright (C) 2002 Frank Mori Hess <fmhess@users.sourceforge.net>
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
-- 
2.1.0

