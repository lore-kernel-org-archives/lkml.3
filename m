Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab3LSL6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:58:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab3LSL55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 109/208] mei: me: add Lynx Point Wellsburg work station device id
Date: Thu, 19 Dec 2013 11:53:27 +0000
Message-Id: <1387454106-19326-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 838b3a6d62413b336f3dde15ecff161070358957 upstream.

add missing device id for LPT based work station

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/misc/mei/hw-me-regs.h | 1 +
 drivers/misc/mei/pci-me.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 6a203b6..6c0fde5 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -110,6 +110,7 @@
 #define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
 
 #define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
+#define MEI_DEV_ID_LPT_W      0x8D3A  /* Lynx Point - Wellsburg */
 #define MEI_DEV_ID_LPT_LP     0x9C3A  /* Lynx Point LP */
 /*
  * MEI HW Section
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 1b3844e..a0a5e72 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -77,6 +77,7 @@ static DEFINE_PCI_DEVICE_TABLE(mei_me_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_2)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_3)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_W)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_LP)},
 
 	/* required last entry */
-- 
1.8.3.2

