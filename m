Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935277Ab3BTLOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:14:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935216Ab3BTLM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:12:59 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 2/6] ghes_edac: add a MAINTAINERS entry and copyrights
Date: Wed, 20 Feb 2013 08:12:48 -0300
Message-Id: <c5ba86f0ff78110f0fe37450a2a82c3c43383e24.1361358127.git.mchehab@redhat.com>
In-Reply-To: <cover.1361358127.git.mchehab@redhat.com>
References: <cover.1361358127.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the driver inside MAINTAINERS file and fill the driver's
Copyright information.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS              |  7 +++++++
 drivers/edac/ghes_edac.c | 11 +++++++++++
 2 files changed, 18 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 35a56bc..889644d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2803,6 +2803,13 @@ W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/e7xxx_edac.c
 
+EDAC-GHES
+M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+L:	linux-edac@vger.kernel.org
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+F:	drivers/edac/ghes-edac.c
+
 EDAC-I82443BXGX
 M:	Tim Small <tim@buttersideup.com>
 L:	linux-edac@vger.kernel.org
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 565c516..ef54829 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -1,3 +1,14 @@
+/*
+ * GHES/EDAC Linux driver
+ *
+ * This file may be distributed under the terms of the GNU General Public
+ * License version 2.
+ *
+ * Copyright (c) 2013 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * Red Hat Inc. http://www.redhat.com
+ */
+
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <acpi/ghes.h>
-- 
1.8.1.2

