Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaH3FzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 01:55:18 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:64022 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaH3FzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 01:55:17 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: addi_apci_1564: move boilerplate text to addi_apci_1564.c
Date: Sat, 30 Aug 2014 00:55:01 -0500
Message-Id: <1409378101-20134-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 23 ----------------------
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 23 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 198c627..d73db42 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -1,26 +1,3 @@
-/*
- * Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
- *
- *	ADDI-DATA GmbH
- *	Dieselstrasse 3
- *	D-77833 Ottersweier
- *	Tel: +19(0)7223/9493-0
- *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data.com
- *	info@addi-data.com
- *
- * This program is free software; you can redistribute it and/or modify it under
- * the terms of the GNU General Public License as published by the Free Software
- * Foundation; either version 2 of the License, or (at your option) any later
- * version.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
- * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
- * details.
- *
- */
-
 /* Digital Input IRQ Function Selection */
 #define APCI1564_DI_INT_OR				(0 << 1)
 #define APCI1564_DI_INT_AND				(1 << 1)
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 16c02c8..6df3603 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -1,3 +1,26 @@
+/*
+ * addi_apci_1564.c
+ * Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
+ *
+ *	ADDI-DATA GmbH
+ *	Dieselstrasse 3
+ *	D-77833 Ottersweier
+ *	Tel: +19(0)7223/9493-0
+ *	Fax: +49(0)7223/9493-92
+ *	http://www.addi-data.com
+ *	info@addi-data.com
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License as published by the Free Software
+ * Foundation; either version 2 of the License, or (at your option) any later
+ * version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
+ * details.
+ */
+
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
-- 
2.1.0

