Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3LBXcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:32:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:14645 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3LBXcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:32:18 -0500
X-AuditID: cbfee691-b7f666d0000048b0-6e-529d1881b275
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 38/39] PCI: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:32:16 +0900
Message-id: <003b01ceefb6$bca43ed0$35ecbc70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABV/3A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zA91GiblBBkt26VssacqwaF68ns3i
	8sJLrBaXd81hszg77zibA6vHgk2lHvvnrmH36NuyitHj8ya5AJYoLpuU1JzMstQifbsErowD
	W3kKngpUnLp/kqWB8RFvFyMnh4SAicSGR6/YIGwxiQv31gPZXBxCAssYJZZevsYEU/Tvwjtm
	iMQiRokLE/pYQBJCAr8YJZZf0QSx2QTUJL58OcwOYosImEpsfD+FEaSBWaCDUeLatNusEA22
	EtNfbAaaysHBKWAn0fepFiQsLOAgcbJ3CVgJi4CqxLYX58EW8wKVfzmyihHCFpT4Mfke2F5m
	AS2J9TuPM0HY8hKb17xlBhkpIaAu8eivLsQJRhLPpx+GKhGR2PfiHdg5EgKX2CUabj9lgdgl
	IPFt8iEWiF5ZiU0HmCH+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchU
	rzgxt7g0L10vOT93EyMkMifuYLx/wPoQYzLQ+onMUqLJ+cDIziuJNzQ2M7IwNTE1NjK3NCNN
	WEmcN/1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxv1M7H+eh29fvbixXLhx8aLD6/dN
	/6H+47jEARvThh3yItKNq388uXvVey3PD8nNWQfuPg0pfl09a2/f/aUbrupNCz4vcbaXbW/o
	T+aJ13mOtqkIKTrkbyiTvb3M59ybYLF3q4UnvZSrcKo0N9QsXO5rb8U1uUZ08c+P99oT9e6F
	rPzDYy8767wSS3FGoqEWc1FxIgBPc9FU4gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jAd1GiblBBg0nFS2WNGVYNC9ez2Zx
	eeElVovLu+awWZydd5zNgdVjwaZSj/1z17B79G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr4dpgmh
	IW66FjCNEbq+IUFwPUYGaCBhHWPGga08BU8FKk7dP8nSwPiIt4uRk0NCwETi34V3zBC2mMSF
	e+vZuhi5OIQEFjFKXJjQxwKSEBL4xSix/IomiM0moCbx5cthdhBbRMBUYuP7KYwgDcwCHYwS
	16bdZoVosJWY/mIzUxcjBwengJ1E36dakLCwgIPEyd4lYCUsAqoS216cZwKxeYHKvxxZxQhh
	C0r8mHwPbC+zgJbE+p3HmSBseYnNa94yg4yUEFCXePRXF+IEI4nn0w9DlYhI7HvxjnECo9As
	JJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjvtn0jsYVzVYHGIU
	4GBU4uF9sH1OkBBrYllxZe4hRgkOZiUR3k6euUFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWa
	nA9MSXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwFgoVXnb
	LOkJg9S5LVPu5y5j0tp/8lvErL3Mf5k8OmcvWV+/6o2uWOBLnjuqYr5i7YJPJ/xbtDq/78I+
	fb420zd/VyZPepNhn/CpwaB/mXq/tlGUFseF3rDzWfnBzoIFb0IifzFPY8xo2HlV8sHFgtn+
	9tPsCnj+3fy+7V94YmWhTkimuLVbrhJLcUaioRZzUXEiAF0gT8o/AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred. Also, the definition of DEFINE_PCI_DEVICE_TABLE
macro is removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 Documentation/PCI/pci.txt |    3 +--
 drivers/pci/ioapic.c      |    2 +-
 include/linux/pci.h       |   10 ----------
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/Documentation/PCI/pci.txt b/Documentation/PCI/pci.txt
index 6f45856..2f14be7 100644
--- a/Documentation/PCI/pci.txt
+++ b/Documentation/PCI/pci.txt
@@ -123,8 +123,7 @@ initialization with a pointer to a structure describing the driver
 
 
 The ID table is an array of struct pci_device_id entries ending with an
-all-zero entry; use of the macro DEFINE_PCI_DEVICE_TABLE is the preferred
-method of declaring the table.  Each entry consists of:
+all-zero entry; Each entry consists of:
 
 	vendor,device	Vendor and device ID to match (or PCI_ANY_ID)
 
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 50ce680..d9d249a2 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -99,7 +99,7 @@ static void ioapic_remove(struct pci_dev *dev)
 }
 
 
-static DEFINE_PCI_DEVICE_TABLE(ioapic_devices) = {
+static const struct pci_device_id ioapic_devices[] = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOAPIC, ~0) },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOXAPIC, ~0) },
 	{ }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1084a15..6c1f6af 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -631,16 +631,6 @@ struct pci_driver {
 #define	to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
 
 /**
- * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
- * @_table: device table name
- *
- * This macro is used to create a struct pci_device_id array (a device table)
- * in a generic manner.
- */
-#define DEFINE_PCI_DEVICE_TABLE(_table) \
-	const struct pci_device_id _table[]
-
-/**
  * PCI_DEVICE - macro used to describe a specific pci device
  * @vend: the 16 bit PCI Vendor ID
  * @dev: the 16 bit PCI Device ID
-- 
1.7.10.4


