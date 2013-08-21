Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3HUBuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 21:50:14 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55590 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3HUBuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 21:50:12 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r7L1kXQT012680, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 3/3] mmc:memstick:rtsx: Modify copyright comments
Date: Wed, 21 Aug 2013 09:46:27 +0800
Message-ID: <71887e184199dd874a908b396440c992bad98f73.1377049122.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1377049122.git.wei_wang@realsil.com.cn>
References: <cover.1377049122.git.wei_wang@realsil.com.cn>
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
 drivers/memstick/host/rtsx_pci_ms.c |    3 +--
 drivers/mmc/host/rtsx_pci_sdmmc.c   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/host/rtsx_pci_ms.c b/drivers/memstick/host/rtsx_pci_ms.c
index 64a779c..cf8bd72 100644
--- a/drivers/memstick/host/rtsx_pci_ms.c
+++ b/drivers/memstick/host/rtsx_pci_ms.c
@@ -1,6 +1,6 @@
 /* Realtek PCI-Express Memstick Card Interface driver
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
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 0fefe4e..375a880e 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1,6 +1,6 @@
 /* Realtek PCI-Express SD/MMC Card Interface driver
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
-- 
1.7.9.5

