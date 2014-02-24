Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaBXUIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 15:08:40 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53920 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaBXUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 15:08:36 -0500
From: Jon Mason <jdmason@kudzu.us>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] staging/rtl8192e: Remove unused code
Date: Mon, 24 Feb 2014 13:08:20 -0700
Message-Id: <1393272500-1862-2-git-send-email-jdmason@kudzu.us>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393272500-1862-1-git-send-email-jdmason@kudzu.us>
References: <1393272500-1862-1-git-send-email-jdmason@kudzu.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused #defines, structure, and inlined functions for the
rtl8192e driver.  Compile tested only.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_pci.h | 52 -----------------------------
 1 file changed, 52 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_pci.h b/drivers/staging/rtl8192e/rtl8192e/rtl_pci.h
index 356aec4..4b94653 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_pci.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_pci.h
@@ -28,31 +28,6 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 
-static inline void NdisRawWritePortUlong(u32 port,  u32 val)
-{
-	outl(val, port);
-}
-
-static inline void NdisRawWritePortUchar(u32 port,  u8 val)
-{
-	outb(val, port);
-}
-
-static inline void NdisRawReadPortUchar(u32 port, u8 *pval)
-{
-	*pval = inb(port);
-}
-
-static inline void NdisRawReadPortUshort(u32 port, u16 *pval)
-{
-	*pval = inw(port);
-}
-
-static inline void NdisRawReadPortUlong(u32 port, u32 *pval)
-{
-	*pval = inl(port);
-}
-
 struct mp_adapter {
 	u8		LinkCtrlReg;
 
@@ -70,33 +45,6 @@ struct mp_adapter {
 	u8		PciBridgeLinkCtrlReg;
 };
 
-struct rt_pci_capab_header {
-	unsigned char   CapabilityID;
-	unsigned char   Next;
-};
-
-#define PCI_MAX_BRIDGE_NUMBER				255
-#define PCI_MAX_DEVICES						32
-#define PCI_MAX_FUNCTION					8
-
-#define PCI_CONF_ADDRESS					0x0CF8
-#define PCI_CONF_DATA						0x0CFC
-
-#define	PCI_CLASS_BRIDGE_DEV				0x06
-#define	PCI_SUBCLASS_BR_PCI_TO_PCI		0x04
-
-#define	U1DONTCARE						0xFF
-#define	U2DONTCARE						0xFFFF
-#define	U4DONTCARE						0xFFFFFFFF
-
-#define	INTEL_VENDOR_ID					0x8086
-#define	SIS_VENDOR_ID						0x1039
-#define	ATI_VENDOR_ID						0x1002
-#define	ATI_DEVICE_ID						0x7914
-#define	AMD_VENDOR_ID						0x1022
-
-#define PCI_CAPABILITY_ID_PCI_EXPRESS		0x10
-
 struct net_device;
 bool rtl8192_pci_findadapter(struct pci_dev *pdev, struct net_device *dev);
 
-- 
1.8.3.2

