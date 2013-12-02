Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3LBXPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:15:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34190 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3LBXPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:15:41 -0500
X-AuditID: cbfee691-b7f666d0000048b0-c3-529d149bc95d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 16/39] mfd: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:15:39 +0900
Message-id: <002501ceefb4$6a4e2120$3eea6360$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAw8wQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zY93ZInODDH60W1o0L17PZnF54SVW
	i/tfjzJaXN41h83idDerA6vHnWt72DzmnQz02D93DbtH35ZVjB6fN8kFsEZx2aSk5mSWpRbp
	2yVwZcy+3cVSMEe34k/DArYGxreqXYycHBICJhK//x5hgbDFJC7cW8/WxcjFISSwjFHi2LH9
	7F2MHGBFfw7JQcSnM0os37iaEcL5xSjxcfcmNpBuNgE1iS9fDrOD2CICphIb308BK2IWmMQo
	0T39A9gKIQFbiekvNjOBTOUUsJPo+1QLEhYWcJDYtuIGM4jNIqAq8fv0R7CZvEDlnfPvM0HY
	ghI/Jt8DG8MsoCWxfudxJghbXmLzmrfMEIeqSzz6qwtxgpHE2jdLGCFKRCT2vXgHdo6EwD12
	ibUPrjFC7BKQ+Db5EAtEr6zEpgPMkICQlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1
	ILmgOCm9yFSvODG3uDQvXS85P3cTIyRKJ+5gvH/A+hBjMtD6icxSosn5wCjPK4k3NDYzsjA1
	MTU2Mrc0I01YSZw3/VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGzXsHjicoWVp6yHo7
	SbX1Xj8jF6e6zu97a8cENl7e76pfOias7vDaoNlrGidR6WC8IiM6xUZj3U7LuOBtPy1n7qrR
	1XFfdZ/JcupJdgWL865nZ8QcfffQvoh71YrOoBU67rceTLWI0D/xIyKj7OLBp+vjd7d8Kdfc
	0tn0eg2bW9L3Mi2jmBlKLMUZiYZazEXFiQDVaAiZ6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd3ZInODDBYuNLFoXryezeLywkus
	Fve/HmW0uLxrDpvF6W5WB1aPO9f2sHnMOxnosX/uGnaPvi2rGD0+b5ILYI1qYLTJSE1MSS1S
	SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
	0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8yYfbuLpWCObsWfhgVsDYxvVbsYOTgkBEwk/hyS
	62LkBDLFJC7cW8/WxcjFISQwnVFi+cbVjBDOL0aJj7s3sYFUsQmoSXz5cpgdxBYRMJXY+H4K
	WBGzwCRGie7pH1hAEkICthLTX2xmAtnAKWAn0fepFiQsLOAgsW3FDWYQm0VAVeL36Y9gM3mB
	yjvn32eCsAUlfky+BzaGWUBLYv3O40wQtrzE5jVvmSGOVpd49FcX4gQjibVvljBClIhI7Hvx
	jnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITgHPpHYw
	rmywOMQowMGoxMP7YPucICHWxLLiytxDjBIczEoivJ08c4OEeFMSK6tSi/Lji0pzUosPMSYD
	PTqRWUo0OR+YnvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1Oq
	gdFd4M1qUb7H9fKvpbX6fSakpDV+/xASPvul+pobS278KOLmi+L7NXuCa51O3hzfSB/upZ9f
	P/O/LpKSMXtax9kN2xadM11U+ixFPPlrUXJURe8+15d7jSdU/q6qXaD78tOkCKakrQ9CmCZ/
	tfSs22+/9PSf3M07Yp7ry7fsOlm740hwe/x6zu1KLMUZiYZazEXFiQD/l7FdRQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/cs5535-mfd.c          |    2 +-
 drivers/mfd/janz-cmodio.c         |    2 +-
 drivers/mfd/lpc_ich.c             |    2 +-
 drivers/mfd/lpc_sch.c             |    2 +-
 drivers/mfd/rdc321x-southbridge.c |    2 +-
 drivers/mfd/rtsx_pcr.c            |    2 +-
 drivers/mfd/sm501.c               |    2 +-
 drivers/mfd/sta2x11-mfd.c         |    2 +-
 drivers/mfd/timberdale.c          |    2 +-
 drivers/mfd/vx855.c               |    2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
index 2e4752a..17c1301 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -172,7 +172,7 @@ static void cs5535_mfd_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(cs5535_mfd_pci_tbl) = {
+static const struct pci_device_id cs5535_mfd_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_ISA) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
 	{ 0, }
diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index fcbb2e9..81b7d88 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -265,7 +265,7 @@ static void cmodio_pci_remove(struct pci_dev *dev)
 #define PCI_VENDOR_ID_JANZ		0x13c3
 
 /* The list of devices that this module will support */
-static DEFINE_PCI_DEVICE_TABLE(cmodio_pci_ids) = {
+static const struct pci_device_id cmodio_pci_ids[] = {
 	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030, PCI_VENDOR_ID_JANZ, 0x0101 },
 	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050, PCI_VENDOR_ID_JANZ, 0x0100 },
 	{ 0, }
diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index da1c656..c17f8db 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -517,7 +517,7 @@ static struct lpc_ich_info lpc_chipset_info[] = {
  * pci_driver, because the I/O Controller Hub has also other
  * functions that probably will be registered by other drivers.
  */
-static DEFINE_PCI_DEVICE_TABLE(lpc_ich_ids) = {
+static const struct pci_device_id lpc_ich_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x2410), LPC_ICH},
 	{ PCI_VDEVICE(INTEL, 0x2420), LPC_ICH0},
 	{ PCI_VDEVICE(INTEL, 0x2440), LPC_ICH2},
diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index fbfbf0b..3bb05c0 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -76,7 +76,7 @@ static struct mfd_cell wdt_sch_cell = {
 	.ignore_resource_conflicts = true,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(lpc_sch_ids) = {
+static const struct pci_device_id lpc_sch_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ITC_LPC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CENTERTON_ILB) },
diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index 21b7bef..293d222 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -96,7 +96,7 @@ static void rdc321x_sb_remove(struct pci_dev *pdev)
 	mfd_remove_devices(&pdev->dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(rdc321x_sb_table) = {
+static const struct pci_device_id rdc321x_sb_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030) },
 	{}
 };
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 11e20af..8ab8f1d 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -50,7 +50,7 @@ static struct mfd_cell rtsx_pcr_cells[] = {
 	},
 };
 
-static DEFINE_PCI_DEVICE_TABLE(rtsx_pci_ids) = {
+static const struct pci_device_id rtsx_pci_ids[] = {
 	{ PCI_DEVICE(0x10EC, 0x5209), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5229), PCI_CLASS_OTHERS << 16, 0xFF0000 },
 	{ PCI_DEVICE(0x10EC, 0x5289), PCI_CLASS_OTHERS << 16, 0xFF0000 },
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index c2c8c91..e7dc441 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1710,7 +1710,7 @@ static int sm501_plat_remove(struct platform_device *dev)
 	return 0;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(sm501_pci_tbl) = {
+static const struct pci_device_id sm501_pci_tbl[] = {
 	{ 0x126f, 0x0501, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ 0, },
 };
diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 65c6fa6..53ab686 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -642,7 +642,7 @@ err_disable:
 	return err;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(sta2x11_mfd_tbl) = {
+static const struct pci_device_id sta2x11_mfd_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_GPIO)},
 	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_VIC)},
 	{0,},
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index dbb34f9..8db071c 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -851,7 +851,7 @@ static void timb_remove(struct pci_dev *dev)
 	kfree(priv);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(timberdale_pci_tbl) = {
+static const struct pci_device_id timberdale_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TIMB, PCI_DEVICE_ID_TIMB) },
 	{ 0 }
 };
diff --git a/drivers/mfd/vx855.c b/drivers/mfd/vx855.c
index 757ecc63..c4730fa 100644
--- a/drivers/mfd/vx855.c
+++ b/drivers/mfd/vx855.c
@@ -118,7 +118,7 @@ static void vx855_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(vx855_pci_tbl) = {
+static const struct pci_device_id vx855_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },
 	{ 0, }
 };
-- 
1.7.10.4


