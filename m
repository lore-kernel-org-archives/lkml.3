Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3LBXa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:30:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:31394 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3LBXaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:30:24 -0500
X-AuditID: cbfee68f-b7f336d00000481b-86-529d180f0630
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Wim Van Sebroeck'" <wim@iguana.be>, linux-watchdog@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 35/39] watchdog: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:30:22 +0900
Message-id: <003801ceefb6$78d25660$6a770320$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABR54A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zQ11+iblBBr03BCyaF69ns7i88BKr
	xeVdc9gsbqzbx25xa8YLVgdWj2ubxTz2z13D7tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	0/qmMBfc1q74uDK/gfGFShcjJ4eEgInE4mVfmCBsMYkL99azgdhCAssYJTZsk4SpebBiKjtE
	fBGjxJr5UDW/GCXO3DUCsdkE1CS+fDkMViMiYCqx8f0Uxi5GLg5mgS5GiWVb70E120pMf7EZ
	aBkHB6eAnUTfp1qQsLCAq8TX6dNZQWwWAVWJY98PMIPYvEDlrbtPsUHYghI/Jt9jAbGZBbQk
	1u88zgRhy0tsXvOWGWSkhIC6xKO/uhAnGEnMWj+TDaJERGLfi3dg50gIXGKXODp3D9QuAYlv
	kw+xQPTKSmyCWCshIClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGxXnFi
	bnFpXrpecn7uJkZIXPbvYLx7wPoQYzLQ+onMUqLJ+cC4ziuJNzQ2M7IwNTE1NjK3NCNNWEmc
	9/7DpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjEsdM4LMth6evnfy8Z95q36pCM54sMJt
	ypOHfmUTX1W23/l96MqCT1HqBxeZXdXfy8BQxjWn8P5d3zqDPb+01+8LTXJu6f4qJ/DxypUr
	kVNSqpklBSvuv2ddp/5gt2FcqsrD/J2C29Qn9TVNEVVvLTPxOmqf+5m35OaZZXc0I8vPP95/
	3/2jfoYSS3FGoqEWc1FxIgABaddP4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jAV1+iblBBg3TeCyaF69ns7i88BKr
	xeVdc9gsbqzbx25xa8YLVgdWj2ubxTz2z13D7tG3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGdP6pjAX3Nau+Lgyv4HxhUoXIyeHhICJxIMVU9khbDGJ
	C/fWs4HYQgKLGCXWzIeyfzFKnLlrBGKzCahJfPlyGKxeRMBUYuP7KYxdjFwczAJdjBLLtt5j
	h2iwlZj+YjNTFyMHB6eAnUTfp1qQsLCAq8TX6dNZQWwWAVWJY98PMIPYvEDlrbtPsUHYghI/
	Jt9jAbGZBbQk1u88zgRhy0tsXvOWGWSkhIC6xKO/uhAnGEnMWj+TDaJERGLfi3eMExiFZiGZ
	NAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDcP5PewbiqweIQowAH
	oxIP74Ptc4KEWBPLiitzDzFKcDArifB28swNEuJNSaysSi3Kjy8qzUktPsSYDPToRGYp0eR8
	YErKK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZG/TQem/e/
	JF53Wsc9PeUpN32fvcOk7UsD1vTNFjrnuzl+09E797PKEti/PY65fP6UkeZP746lrxOWdVnN
	Otzi+fCeep2S3TMOJe9LHzadKNhY8X6uiaLdUunXrWWPgkQO7XLJ6pr61ivE2c9bbFpNQfTv
	89Wd+kbZS5+u+h2Yrl36j7WWkZVPiaU4I9FQi7moOBEAkoTe1z8DAAA=
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
 drivers/watchdog/alim1535_wdt.c |    2 +-
 drivers/watchdog/alim7101_wdt.c |    2 +-
 drivers/watchdog/hpwdt.c        |    2 +-
 drivers/watchdog/i6300esb.c     |    2 +-
 drivers/watchdog/nv_tco.c       |    2 +-
 drivers/watchdog/pcwd_pci.c     |    2 +-
 drivers/watchdog/sp5100_tco.c   |    2 +-
 drivers/watchdog/via_wdt.c      |    2 +-
 drivers/watchdog/wdt_pci.c      |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index fbb7b94..3a17fbd 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -301,7 +301,7 @@ static int ali_notify_sys(struct notifier_block *this,
  *	want to register another driver on the same PCI id.
  */
 
-static DEFINE_PCI_DEVICE_TABLE(ali_pci_tbl) __used = {
+static const struct pci_device_id ali_pci_tbl[] __used = {
 	{ PCI_VENDOR_ID_AL, 0x1533, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 12f0b76..996b2f7 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -414,7 +414,7 @@ err_out:
 module_init(alim7101_wdt_init);
 module_exit(alim7101_wdt_unload);
 
-static DEFINE_PCI_DEVICE_TABLE(alim7101_pci_tbl) __used = {
+static const struct pci_device_id alim7101_pci_tbl[] __used = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ }
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 45b979d..4f1c3e0 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -55,7 +55,7 @@ static void __iomem *pci_mem_addr;		/* the PCI-memory address */
 static unsigned long __iomem *hpwdt_timer_reg;
 static unsigned long __iomem *hpwdt_timer_con;
 
-static DEFINE_PCI_DEVICE_TABLE(hpwdt_devices) = {
+static const struct pci_device_id hpwdt_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB203) },	/* iLO2 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3306) },	/* iLO3 */
 	{0},			/* terminate list */
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index a72fe93..25a2bfd 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -334,7 +334,7 @@ static struct miscdevice esb_miscdev = {
 /*
  * Data for PCI driver interface
  */
-static DEFINE_PCI_DEVICE_TABLE(esb_pci_tbl) = {
+static const struct pci_device_id esb_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_9), },
 	{ 0, },                 /* End of list */
 };
diff --git a/drivers/watchdog/nv_tco.c b/drivers/watchdog/nv_tco.c
index 231e5b9..0b9ec61 100644
--- a/drivers/watchdog/nv_tco.c
+++ b/drivers/watchdog/nv_tco.c
@@ -289,7 +289,7 @@ static struct miscdevice nv_tco_miscdev = {
  * register a pci_driver, because someone else might one day
  * want to register another driver on the same PCI id.
  */
-static DEFINE_PCI_DEVICE_TABLE(tco_pci_tbl) = {
+static const struct pci_device_id tco_pci_tbl[] = {
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SMBUS,
 	  PCI_ANY_ID, PCI_ANY_ID, },
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS,
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index b4864f2..c0d07ee 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -801,7 +801,7 @@ static void pcipcwd_card_exit(struct pci_dev *pdev)
 	cards_found--;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pcipcwd_pci_tbl) = {
+static const struct pci_device_id pcipcwd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_QUICKLOGIC, PCI_DEVICE_ID_WATCHDOG_PCIPCWD,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 },			/* End of list */
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index ce63a1b..5cca9cd 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -303,7 +303,7 @@ static struct miscdevice sp5100_tco_miscdev = {
  * register a pci_driver, because someone else might
  * want to register another driver on the same PCI id.
  */
-static DEFINE_PCI_DEVICE_TABLE(sp5100_tco_pci_tbl) = {
+static const struct pci_device_id sp5100_tco_pci_tbl[] = {
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS, PCI_ANY_ID,
 	  PCI_ANY_ID, },
 	{ 0, },			/* End of list */
diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
index 1a68f76..d2cd9f0 100644
--- a/drivers/watchdog/via_wdt.c
+++ b/drivers/watchdog/via_wdt.c
@@ -239,7 +239,7 @@ static void wdt_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(wdt_pci_table) = {
+static const struct pci_device_id wdt_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX800) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index ee89ba4..3dc578e 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -720,7 +720,7 @@ static void wdtpci_remove_one(struct pci_dev *pdev)
 }
 
 
-static DEFINE_PCI_DEVICE_TABLE(wdtpci_pci_tbl) = {
+static const struct pci_device_id wdtpci_pci_tbl[] = {
 	{
 		.vendor	   = PCI_VENDOR_ID_ACCESSIO,
 		.device	   = PCI_DEVICE_ID_ACCESSIO_WDG_CSM,
-- 
1.7.10.4


