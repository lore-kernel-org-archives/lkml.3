Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3GDMgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:36:09 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:18715 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab3GDMgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:36:05 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <joe@perches.com>, <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH v2 5/5] staging: ozwpan: Rename Kbuild to Makefile
Date: Thu, 4 Jul 2013 13:35:31 +0100
Message-ID: <1372941331-9586-6-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372255013.2076.4.camel@joe-AO722>
References: <1372255013.2076.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/Kbuild   |   16 ----------------
 drivers/staging/ozwpan/Makefile |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 16 deletions(-)
 delete mode 100644 drivers/staging/ozwpan/Kbuild
 create mode 100644 drivers/staging/ozwpan/Makefile

diff --git a/drivers/staging/ozwpan/Kbuild b/drivers/staging/ozwpan/Kbuild
deleted file mode 100644
index 29529c1..0000000
--- a/drivers/staging/ozwpan/Kbuild
+++ /dev/null
@@ -1,16 +0,0 @@
-# -----------------------------------------------------------------------------
-# Copyright (c) 2011 Ozmo Inc
-# Released under the GNU General Public License Version 2 (GPLv2).
-# -----------------------------------------------------------------------------
-
-obj-$(CONFIG_USB_WPAN_HCD) += ozwpan.o
-ozwpan-y := \
-	ozmain.o \
-	ozpd.o \
-	ozusbsvc.o \
-	ozusbsvc1.o \
-	ozhcd.o \
-	ozeltbuf.o \
-	ozproto.o \
-	ozcdev.o \
-	ozurbparanoia.o
diff --git a/drivers/staging/ozwpan/Makefile b/drivers/staging/ozwpan/Makefile
new file mode 100644
index 0000000..29529c1
--- /dev/null
+++ b/drivers/staging/ozwpan/Makefile
@@ -0,0 +1,16 @@
+# -----------------------------------------------------------------------------
+# Copyright (c) 2011 Ozmo Inc
+# Released under the GNU General Public License Version 2 (GPLv2).
+# -----------------------------------------------------------------------------
+
+obj-$(CONFIG_USB_WPAN_HCD) += ozwpan.o
+ozwpan-y := \
+	ozmain.o \
+	ozpd.o \
+	ozusbsvc.o \
+	ozusbsvc1.o \
+	ozhcd.o \
+	ozeltbuf.o \
+	ozproto.o \
+	ozcdev.o \
+	ozurbparanoia.o
-- 
1.7.9.5

