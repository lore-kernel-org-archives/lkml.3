Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab3LSMdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:33:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44955 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab3LSL56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 110/208] mei: add 9 series PCH mei device ids
Date: Thu, 19 Dec 2013 11:53:28 +0000
Message-Id: <1387454106-19326-111-git-send-email-luis.henriques@canonical.com>
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

commit 76a9635979e543f04a5885198e68ff28e3311b67 upstream.

And Lynx Point H Refresh and Wildcat Point LP
device ids.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/misc/mei/hw-me-regs.h | 5 ++++-
 drivers/misc/mei/pci-me.c     | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 6c0fde5..66f411a 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -109,9 +109,12 @@
 #define MEI_DEV_ID_PPT_2      0x1CBA  /* Panther Point */
 #define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
 
-#define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
+#define MEI_DEV_ID_LPT_H      0x8C3A  /* Lynx Point H */
 #define MEI_DEV_ID_LPT_W      0x8D3A  /* Lynx Point - Wellsburg */
 #define MEI_DEV_ID_LPT_LP     0x9C3A  /* Lynx Point LP */
+#define MEI_DEV_ID_LPT_HR     0x8CBA  /* Lynx Point H Refresh */
+
+#define MEI_DEV_ID_WPT_LP     0x9CBA  /* Wildcat Point LP */
 /*
  * MEI HW Section
  */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a0a5e72..e637318 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -76,9 +76,11 @@ static DEFINE_PCI_DEVICE_TABLE(mei_me_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_1)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_2)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_3)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_H)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_W)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_LP)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_HR)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_WPT_LP)},
 
 	/* required last entry */
 	{0, }
-- 
1.8.3.2

