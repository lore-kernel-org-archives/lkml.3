Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3LBXBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:01:52 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32204 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3LBXBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:01:48 -0500
X-AuditID: cbfee691-b7f666d0000048b0-ed-529d11555f81
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 03/39] block: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:01:40 +0900
Message-id: <001801ceefb2$7679e440$636dacc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAQX6w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zQ91QwblBBpcfiVjMWb+GzaJ58Xo2
	i8sLL7FaXN41h82BxePEjN8sHvvnrmH36NuyitHj8ya5AJYoLpuU1JzMstQifbsErowX8y8x
	FxwRqei9rNLAuEiwi5GTQ0LARGLVwUesELaYxIV769m6GLk4hASWMUq07VzIBlM0e3UTM0Ri
	OqPE7odNjBDOL0aJhZsWMIFUsQmoSXz5cpgdxBYRMJXY+H4KI4jNLFAsMfHML7BJQgK2EtNf
	bAaq5+DgFLCT6PtUCxIWFnCS2HSjmwUkzCKgKvF4ujRImBeoeuvSmSwQtqDEj8n3WCAmakms
	33mcCcKWl9i85i0zSKuEgLrEo7+6EAcYSSxq3wJVLiKx78U7sIslBM6xS/x7exYswSIgIPFt
	8iEWiF5ZiU0HmCHelZQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchUrzgx
	t7g0L10vOT93EyMkIifuYLx/wPoQYzLQ+onMUqLJ+cCIziuJNzQ2M7IwNTE1NjK3NCNNWEmc
	N/1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxrLju7ysXF6/yD2+Y9Waj4tzWAL8D1T8
	XiGY6Xzu6YuyxA3N0+bXytXt0rutfc5ae1mhhHyu9x2tb7dPWIrLTvnD9maF++35pw5KLZ7/
	demJu47s/ja7lssmJkX8LQgKYJyjtUbb9ERKjuLC7c1b0m4tnnR0DoOV49sFKTyndrMfb42e
	WPFyrZISS3FGoqEWc1FxIgCbnOvl3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd1QwblBBhtfCVjMWb+GzaJ58Xo2
	i8sLL7FaXN41h82BxePEjN8sHvvnrmH36NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMF/MvMRccEanovazSwLhIsIuRk0NCwERi9uomZghbTOLCvfVs
	XYxcHEIC0xkldj9sYoRwfjFKLNy0gAmkik1ATeLLl8PsILaIgKnExvdTGEFsZoFiiYlnfrGB
	2EICthLTX2wGqufg4BSwk+j7VAsSFhZwkth0o5sFJMwioCrxeLo0SJgXqHrr0pksELagxI/J
	91ggJmpJrN95nAnClpfYvOYtM0irhIC6xKO/uhAHGEksat8CVS4ise/FO8YJjEKzkEyahWTS
	LCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjON6fSe1gXNlgcYhRgINRiYf3
	wfY5QUKsiWXFlbmHGCU4mJVEeDt55gYJ8aYkVlalFuXHF5XmpBYfYkwG+nMis5Rocj4wFeWV
	xBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+Oa6bd7D2rc4w1u
	1iyL5D+acV7q+qz4iZ/s4pS5rgn/uMVVFLxYstu29vynTZenqV9yKpmZXPxhkrADU9EyLmNr
	5bsJduUfC71Ytj8sTc6RzNHOmbzlw7IFNzvZPCMnvo6++utx0TZ/g6PRWx5MmBxpP12c8xTz
	+yuzKv5qtXfkRWrreO7Wvq7EUpyRaKjFXFScCAAev4POOwMAAA==
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
 drivers/block/mtip32xx/mtip32xx.c |    2 +-
 drivers/block/nvme-core.c         |    2 +-
 drivers/block/rsxx/core.c         |    2 +-
 drivers/block/skd_main.c          |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 050c712..b0bcbb9 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4762,7 +4762,7 @@ static void mtip_pci_shutdown(struct pci_dev *pdev)
 }
 
 /* Table of device ids supported by this driver. */
-static DEFINE_PCI_DEVICE_TABLE(mtip_pci_tbl) = {
+static const struct pci_device_id mtip_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320H_DEVICE_ID) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320M_DEVICE_ID) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320S_DEVICE_ID) },
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 26d03fa..98549c9 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -2263,7 +2263,7 @@ static const struct pci_error_handlers nvme_err_handler = {
 /* Move to pci_ids.h later */
 #define PCI_CLASS_STORAGE_EXPRESS	0x010802
 
-static DEFINE_PCI_DEVICE_TABLE(nvme_id_table) = {
+static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
 };
diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index a8de2ee..820b400 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -1137,7 +1137,7 @@ static const struct pci_error_handlers rsxx_err_handler = {
 	.slot_reset     = rsxx_slot_reset,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(rsxx_pci_ids) = {
+static const struct pci_device_id rsxx_pci_ids[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_FS70_FLASH)},
 	{PCI_DEVICE(PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_FS80_FLASH)},
 	{0,},
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 9199c93..45107a0 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4788,7 +4788,7 @@ static const struct block_device_operations skd_blockdev_ops = {
  *****************************************************************************
  */
 
-static DEFINE_PCI_DEVICE_TABLE(skd_pci_tbl) = {
+static const struct pci_device_id skd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_STEC, PCI_DEVICE_ID_S1120,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
 	{ 0 }                     /* terminate list */
-- 
1.7.10.4


