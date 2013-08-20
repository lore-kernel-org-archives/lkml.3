Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab3HTGTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:19:17 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:48328 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3HTGTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:19:15 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r7K6J3SL020223, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v3 6/6] mfd:rtsx: Modify copyright comments
Date: Tue, 20 Aug 2013 14:18:56 +0800
Message-ID: <98efa40e3c49be841f06fa2337f3499a19c2fee3.1376978825.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1376978825.git.wei_wang@realsil.com.cn>
References: <cover.1376978825.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Update copyright date, and remove author address.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rtl8411.c           |    4 ++--
 drivers/mfd/rts5209.c           |    3 +--
 drivers/mfd/rts5227.c           |    5 +----
 drivers/mfd/rts5229.c           |    3 +--
 drivers/mfd/rts5249.c           |    1 -
 drivers/mfd/rtsx_pcr.c          |    3 +--
 drivers/mfd/rtsx_pcr.h          |    3 +--
 include/linux/mfd/rtsx_common.h |    3 +--
 include/linux/mfd/rtsx_pci.h    |    3 +--
 9 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 37367fb..e4c1833 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,7 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
+ *   Roger Tseng <rogerable@realtek.com>
  */
 
 #include <linux/module.h>
diff --git a/drivers/mfd/rts5209.c b/drivers/mfd/rts5209.c
index ef6a59f..4026e1f 100644
--- a/drivers/mfd/rts5209.c
+++ b/drivers/mfd/rts5209.c
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #include <linux/module.h>
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index c72abd6..d7cae82 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,10 +17,7 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
- *
  *   Roger Tseng <rogerable@realtek.com>
- *   No. 2, Innovation Road II, Hsinchu Science Park, Hsinchu 300, Taiwan
  */
 
 #include <linux/module.h>
diff --git a/drivers/mfd/rts5229.c b/drivers/mfd/rts5229.c
index afb0f24..620e7fa 100644
--- a/drivers/mfd/rts5229.c
+++ b/drivers/mfd/rts5229.c
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #include <linux/module.h>
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 384b30b..ea90f8f 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 128, West Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #include <linux/module.h>
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 29932a0..e6ae772 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #include <linux/pci.h>
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index 7a1b87a..947e79b 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #ifndef __RTSX_PCR_H
diff --git a/include/linux/mfd/rtsx_common.h b/include/linux/mfd/rtsx_common.h
index 2b13970..443176e 100644
--- a/include/linux/mfd/rtsx_common.h
+++ b/include/linux/mfd/rtsx_common.h
@@ -1,6 +1,6 @@
 /* Driver for Realtek driver-based card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #ifndef __RTSX_COMMON_H
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index dd0bd58..daefca1 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -1,6 +1,6 @@
 /* Driver for Realtek PCI-Express card reader
  *
- * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -17,7 +17,6 @@
  *
  * Author:
  *   Wei WANG <wei_wang@realsil.com.cn>
- *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
 #ifndef __RTSX_PCI_H
-- 
1.7.9.5

