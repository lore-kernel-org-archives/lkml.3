Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3LBX0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:26:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13722 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3LBX0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:26:02 -0500
X-AuditID: cbfee68f-b7f336d00000481b-e0-529d17087823
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        devel@driverdev.osuosl.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 28/39] staging: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:26:00 +0900
Message-id: <003101ceefb5$dc1b0380$94510a80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABH3LQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zY10O8blBBg9b9Sz2nPnFbtG8eD2b
	xeWFl1gtLu+aw+bA4nFv32EWj/1z17B79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8baGV/Z
	CmadYar4+GMKYwPju3lMXYycHBICJhIXTkxihrDFJC7cW88GYgsJLGOU+DRNHKbm8dSzQHEu
	oPh0RolLD88xQzi/GCV2HXrBAlLFJqAm8eXLYXYQW0TAVGLj+ymMXYwcHMwCSRKvv4VDDLWV
	mP5iMxNImFPATqLvUy1IWFjAReLvo9tgU1gEVCUer+8Dm8ILVL5j50s2CFtQ4sfke2A1zAJa
	Eut3HmeCsOUlNq95ywwyUkJAXeLRX12IA4wkLi+eDFUuIrHvxTtGkIslBC6xSzw8cJ0VYpeA
	xLfJh1ggemUlNh2ABoOkxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFxnrF
	ibnFpXnpesn5uZsYIVHZv4Px7gHrQ4zJQOsnMkuJJucDozqvJN7Q2MzIwtTE1NjI3NKMNGEl
	cd77D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBOP6xm58OgXGD+LHf6jqdFQr8t2q91
	LE4N3pcZwrmxZ9mG+t8XJVu/v/a59alr06kf+9UOc8yZf/RLohD7ytRr7WqnWT22LhCLnR01
	77VUhIfGh/S+xuB7L12UZ0SLOS3WSG7/u3mGV9Sia0qPtz3kWnAiyrLHQuG9x3fvyM0Otm9d
	L+z6dH6KEktxRqKhFnNRcSIAFLt3w+ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQV0O8blBBse+K1vsOfOL3aJ58Xo2
	i8sLL7FaXN41h82BxePevsMsHvvnrmH36NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMtTO+shXMOsNU8fHHFMYGxnfzmLoYOTkkBEwkHk89ywZhi0lc
	uLceyObiEBKYzihx6eE5ZgjnF6PErkMvWECq2ATUJL58OcwOYosImEpsfD+FsYuRg4NZIEni
	9bdwkLCQgK3E9BebmUDCnAJ2En2fakHCwgIuEn8f3QabwiKgKvF4fR/YFF6g8h07X7JB2IIS
	PybfA6thFtCSWL/zOBOELS+xec1bZpCREgLqEo/+6kIcYCRxefFkqHIRiX0v3jFOYBSahWTS
	LCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwVH/TGoH48oGi0OMAhyM
	Sjy8D7bPCRJiTSwrrsw9xCjBwawkwtvJMzdIiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OB
	CSmvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhhb1cXX3/u7
	zvs31w9Nj2UN9oYli6ofcMpNe/fqbdVac81IjfKAlu0++n73J/keiguKydMWM5qYL+r7bPeC
	yfblWiLsbuKLZx0UcbReIrfsqsP8r5kzgtVtXm77u/eqoqnMwQlLbvxdfynfMPuQBlfjYw21
	Qx5mK8/+WX9UMfhwm3nO/JAXRtVKLMUZiYZazEXFiQA0DAYYPgMAAA==
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
 drivers/staging/comedi/drivers/8255_pci.c         |    2 +-
 drivers/staging/comedi/drivers/addi_apci_035.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c   |    2 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c   |    2 +-
 drivers/staging/comedi/drivers/addi_apci_1516.c   |    2 +-
 drivers/staging/comedi/drivers/addi_apci_1564.c   |    2 +-
 drivers/staging/comedi/drivers/addi_apci_16xx.c   |    2 +-
 drivers/staging/comedi/drivers/addi_apci_2032.c   |    2 +-
 drivers/staging/comedi/drivers/addi_apci_2200.c   |    2 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c   |    2 +-
 drivers/staging/comedi/drivers/addi_apci_3200.c   |    2 +-
 drivers/staging/comedi/drivers/addi_apci_3501.c   |    2 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c   |    2 +-
 drivers/staging/comedi/drivers/adl_pci6208.c      |    2 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c      |    2 +-
 drivers/staging/comedi/drivers/adl_pci8164.c      |    2 +-
 drivers/staging/comedi/drivers/adl_pci9111.c      |    2 +-
 drivers/staging/comedi/drivers/adl_pci9118.c      |    2 +-
 drivers/staging/comedi/drivers/adv_pci1710.c      |    2 +-
 drivers/staging/comedi/drivers/adv_pci1723.c      |    2 +-
 drivers/staging/comedi/drivers/adv_pci1724.c      |    2 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c      |    2 +-
 drivers/staging/comedi/drivers/amplc_dio200_pci.c |    2 +-
 drivers/staging/comedi/drivers/amplc_pc236.c      |    2 +-
 drivers/staging/comedi/drivers/amplc_pci224.c     |    2 +-
 drivers/staging/comedi/drivers/amplc_pci230.c     |    2 +-
 drivers/staging/comedi/drivers/amplc_pci263.c     |    2 +-
 drivers/staging/comedi/drivers/cb_pcidas.c        |    2 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c      |    2 +-
 drivers/staging/comedi/drivers/cb_pcidda.c        |    2 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c       |    2 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c       |    2 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c   |    2 +-
 drivers/staging/comedi/drivers/daqboard2000.c     |    2 +-
 drivers/staging/comedi/drivers/das08_pci.c        |    2 +-
 drivers/staging/comedi/drivers/dt3000.c           |    2 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c     |    2 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c         |    2 +-
 drivers/staging/comedi/drivers/icp_multi.c        |    2 +-
 drivers/staging/comedi/drivers/jr3_pci.c          |    2 +-
 drivers/staging/comedi/drivers/ke_counter.c       |    2 +-
 drivers/staging/comedi/drivers/me4000.c           |    2 +-
 drivers/staging/comedi/drivers/me_daq.c           |    2 +-
 drivers/staging/comedi/drivers/ni_6527.c          |    2 +-
 drivers/staging/comedi/drivers/ni_65xx.c          |    2 +-
 drivers/staging/comedi/drivers/ni_660x.c          |    2 +-
 drivers/staging/comedi/drivers/ni_670x.c          |    2 +-
 drivers/staging/comedi/drivers/ni_labpc_pci.c     |    2 +-
 drivers/staging/comedi/drivers/ni_pcidio.c        |    2 +-
 drivers/staging/comedi/drivers/ni_pcimio.c        |    2 +-
 drivers/staging/comedi/drivers/rtd520.c           |    2 +-
 drivers/staging/comedi/drivers/s626.c             |    2 +-
 drivers/staging/comedi/drivers/skel.c             |    2 +-
 drivers/staging/crystalhd/crystalhd_lnx.c         |    2 +-
 drivers/staging/dwc2/pci.c                        |    2 +-
 drivers/staging/et131x/et131x.c                   |    2 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c       |    2 +-
 drivers/staging/media/solo6x10/solo6x10-core.c    |    2 +-
 drivers/staging/phison/phison.c                   |    2 +-
 drivers/staging/sep/sep_main.c                    |    2 +-
 drivers/staging/slicoss/slicoss.c                 |    2 +-
 drivers/staging/sm7xxfb/sm7xxfb.c                 |    2 +-
 drivers/staging/vt6655/device_main.c              |    2 +-
 drivers/staging/xgifb/XGI_main.h                  |    2 +-
 drivers/staging/xillybus/xillybus_pcie.c          |    2 +-
 65 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255_pci.c b/drivers/staging/comedi/drivers/8255_pci.c
index 432e3f9..ec14acb 100644
--- a/drivers/staging/comedi/drivers/8255_pci.c
+++ b/drivers/staging/comedi/drivers/8255_pci.c
@@ -257,7 +257,7 @@ static int pci_8255_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &pci_8255_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pci_8255_pci_table) = {
+static const struct pci_device_id pci_8255_pci_table[] = {
 	{ PCI_VDEVICE(ADLINK, 0x7224), BOARD_ADLINK_PCI7224 },
 	{ PCI_VDEVICE(ADLINK, 0x7248), BOARD_ADLINK_PCI7248 },
 	{ PCI_VDEVICE(ADLINK, 0x7296), BOARD_ADLINK_PCI7296 },
diff --git a/drivers/staging/comedi/drivers/addi_apci_035.c b/drivers/staging/comedi/drivers/addi_apci_035.c
index 8d229b2..ccd4921 100644
--- a/drivers/staging/comedi/drivers/addi_apci_035.c
+++ b/drivers/staging/comedi/drivers/addi_apci_035.c
@@ -58,7 +58,7 @@ static int apci035_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci035_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci035_pci_table) = {
+static const struct pci_device_id apci035_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA,  0x0300) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/addi_apci_1032.c b/drivers/staging/comedi/drivers/addi_apci_1032.c
index 34ab067..af2306c 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1032.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1032.c
@@ -364,7 +364,7 @@ static int apci1032_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci1032_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci1032_pci_table) = {
+static const struct pci_device_id apci1032_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x1003) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/addi_apci_1500.c b/drivers/staging/comedi/drivers/addi_apci_1500.c
index ae9ded6..74f7ace 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1500.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
@@ -57,7 +57,7 @@ static int apci1500_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci1500_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci1500_pci_table) = {
+static const struct pci_device_id apci1500_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMCC, 0x80fc) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/addi_apci_1516.c b/drivers/staging/comedi/drivers/addi_apci_1516.c
index 9d1b142..e9c5291 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1516.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1516.c
@@ -206,7 +206,7 @@ static int apci1516_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci1516_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci1516_pci_table) = {
+static const struct pci_device_id apci1516_pci_table[] = {
 	{ PCI_VDEVICE(ADDIDATA, 0x1000), BOARD_APCI1016 },
 	{ PCI_VDEVICE(ADDIDATA, 0x1001), BOARD_APCI1516 },
 	{ PCI_VDEVICE(ADDIDATA, 0x1002), BOARD_APCI2016 },
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index c5717d6..6248284 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -55,7 +55,7 @@ static int apci1564_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci1564_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci1564_pci_table) = {
+static const struct pci_device_id apci1564_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x1006) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/addi_apci_16xx.c b/drivers/staging/comedi/drivers/addi_apci_16xx.c
index 5ee204b..28df4b5 100644
--- a/drivers/staging/comedi/drivers/addi_apci_16xx.c
+++ b/drivers/staging/comedi/drivers/addi_apci_16xx.c
@@ -168,7 +168,7 @@ static int apci16xx_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci16xx_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci16xx_pci_table) = {
+static const struct pci_device_id apci16xx_pci_table[] = {
 	{ PCI_VDEVICE(ADDIDATA, 0x1009), BOARD_APCI1648 },
 	{ PCI_VDEVICE(ADDIDATA, 0x100a), BOARD_APCI1696 },
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/addi_apci_2032.c b/drivers/staging/comedi/drivers/addi_apci_2032.c
index c77ee87..c9b933c 100644
--- a/drivers/staging/comedi/drivers/addi_apci_2032.c
+++ b/drivers/staging/comedi/drivers/addi_apci_2032.c
@@ -359,7 +359,7 @@ static int apci2032_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci2032_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci2032_pci_table) = {
+static const struct pci_device_id apci2032_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x1004) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/addi_apci_2200.c b/drivers/staging/comedi/drivers/addi_apci_2200.c
index 7fb32e7..e1a9165 100644
--- a/drivers/staging/comedi/drivers/addi_apci_2200.c
+++ b/drivers/staging/comedi/drivers/addi_apci_2200.c
@@ -134,7 +134,7 @@ static int apci2200_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci2200_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci2200_pci_table) = {
+static const struct pci_device_id apci2200_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x1005) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/addi_apci_3120.c b/drivers/staging/comedi/drivers/addi_apci_3120.c
index 67d09e8..1e6fa56 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3120.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3120.c
@@ -230,7 +230,7 @@ static int apci3120_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci3120_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci3120_pci_table) = {
+static const struct pci_device_id apci3120_pci_table[] = {
 	{ PCI_VDEVICE(AMCC, 0x818d), BOARD_APCI3120 },
 	{ PCI_VDEVICE(AMCC, 0x828d), BOARD_APCI3001 },
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/addi_apci_3200.c b/drivers/staging/comedi/drivers/addi_apci_3200.c
index 1213d5a..9868a53 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3200.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3200.c
@@ -109,7 +109,7 @@ static int apci3200_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci3200_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci3200_pci_table) = {
+static const struct pci_device_id apci3200_pci_table[] = {
 	{ PCI_VDEVICE(ADDIDATA, 0x3000), BOARD_APCI3200 },
 	{ PCI_VDEVICE(ADDIDATA, 0x3007), BOARD_APCI3300 },
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/addi_apci_3501.c b/drivers/staging/comedi/drivers/addi_apci_3501.c
index 6138440..4cb69ec 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3501.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3501.c
@@ -428,7 +428,7 @@ static int apci3501_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci3501_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci3501_pci_table) = {
+static const struct pci_device_id apci3501_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3001) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/addi_apci_3xxx.c b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
index 761cbf8..ceadf8e 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
@@ -915,7 +915,7 @@ static int apci3xxx_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci3xxx_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(apci3xxx_pci_table) = {
+static const struct pci_device_id apci3xxx_pci_table[] = {
 	{ PCI_VDEVICE(ADDIDATA, 0x3010), BOARD_APCI3000_16 },
 	{ PCI_VDEVICE(ADDIDATA, 0x300f), BOARD_APCI3000_8 },
 	{ PCI_VDEVICE(ADDIDATA, 0x300e), BOARD_APCI3000_4 },
diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index dd092c795..5c1413a 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -242,7 +242,7 @@ static int adl_pci6208_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(adl_pci6208_pci_table) = {
+static const struct pci_device_id adl_pci6208_pci_table[] = {
 	{ PCI_VDEVICE(ADLINK, 0x6208), BOARD_PCI6208 },
 	{ PCI_VDEVICE(ADLINK, 0x6216), BOARD_PCI6216 },
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/adl_pci7x3x.c b/drivers/staging/comedi/drivers/adl_pci7x3x.c
index 5617f5c..6f622b4 100644
--- a/drivers/staging/comedi/drivers/adl_pci7x3x.c
+++ b/drivers/staging/comedi/drivers/adl_pci7x3x.c
@@ -259,7 +259,7 @@ static int adl_pci7x3x_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(adl_pci7x3x_pci_table) = {
+static const struct pci_device_id adl_pci7x3x_pci_table[] = {
 	{ PCI_VDEVICE(ADLINK, 0x7230), BOARD_PCI7230 },
 	{ PCI_VDEVICE(ADLINK, 0x7233), BOARD_PCI7233 },
 	{ PCI_VDEVICE(ADLINK, 0x7234), BOARD_PCI7234 },
diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index b3d0092..300df55 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -145,7 +145,7 @@ static int adl_pci8164_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(adl_pci8164_pci_table) = {
+static const struct pci_device_id adl_pci8164_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, 0x8164) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index eab8da2..03b38ea 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -938,7 +938,7 @@ static int pci9111_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pci9111_pci_table) = {
+static const struct pci_device_id pci9111_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID) },
 	/* { PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID) }, */
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 9864896..97343cc 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -2217,7 +2217,7 @@ static int adl_pci9118_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(adl_pci9118_pci_table) = {
+static const struct pci_device_id adl_pci9118_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMCC, 0x80d9) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index c3fdcab..bac5e0d 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1374,7 +1374,7 @@ static int adv_pci1710_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(adv_pci1710_pci_table) = {
+static const struct pci_device_id adv_pci1710_pci_table[] = {
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADVANTECH, 0x1710,
 			       PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050),
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index bd4f781..7239426 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -306,7 +306,7 @@ static int adv_pci1723_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(adv_pci1723_pci_table) = {
+static const struct pci_device_id adv_pci1723_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1723) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/adv_pci1724.c b/drivers/staging/comedi/drivers/adv_pci1724.c
index 009a303..56f2d97 100644
--- a/drivers/staging/comedi/drivers/adv_pci1724.c
+++ b/drivers/staging/comedi/drivers/adv_pci1724.c
@@ -381,7 +381,7 @@ static int adv_pci1724_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(adv_pci1724_pci_table) = {
+static const struct pci_device_id adv_pci1724_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1724) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 6bac665..d4bd61d 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1188,7 +1188,7 @@ static int adv_pci_dio_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &adv_pci_dio_driver, cardtype);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(adv_pci_dio_pci_table) = {
+static const struct pci_device_id adv_pci_dio_pci_table[] = {
 	{ PCI_VDEVICE(ADVANTECH, 0x1730), TYPE_PCI1730 },
 	{ PCI_VDEVICE(ADVANTECH, 0x1733), TYPE_PCI1733 },
 	{ PCI_VDEVICE(ADVANTECH, 0x1734), TYPE_PCI1734 },
diff --git a/drivers/staging/comedi/drivers/amplc_dio200_pci.c b/drivers/staging/comedi/drivers/amplc_dio200_pci.c
index a810a24..e036738 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200_pci.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200_pci.c
@@ -439,7 +439,7 @@ static struct comedi_driver dio200_pci_comedi_driver = {
 	.detach = dio200_pci_detach,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(dio200_pci_table) = {
+static const struct pci_device_id dio200_pci_table[] = {
 	{
 		PCI_VDEVICE(AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI215),
 		pci215_model
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 98075f9..eaf21ce 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -567,7 +567,7 @@ static struct comedi_driver amplc_pc236_driver = {
 };
 
 #if DO_PCI
-static DEFINE_PCI_DEVICE_TABLE(pc236_pci_table) = {
+static const struct pci_device_id pc236_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI236) },
 	{0}
 };
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 810e397..4c51a5b 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1498,7 +1498,7 @@ static int amplc_pci224_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(amplc_pci224_pci_table) = {
+static const struct pci_device_id amplc_pci224_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI224) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI234) },
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index a97bbd6..198c2cd 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2856,7 +2856,7 @@ static int amplc_pci230_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(amplc_pci230_pci_table) = {
+static const struct pci_device_id amplc_pci230_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI230) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI260) },
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/amplc_pci263.c b/drivers/staging/comedi/drivers/amplc_pci263.c
index 4bd4ef8..be28e6c 100644
--- a/drivers/staging/comedi/drivers/amplc_pci263.c
+++ b/drivers/staging/comedi/drivers/amplc_pci263.c
@@ -96,7 +96,7 @@ static struct comedi_driver amplc_pci263_driver = {
 	.detach		= comedi_pci_disable,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(pci263_pci_table) = {
+static const struct pci_device_id pci263_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI263) },
 	{0}
 };
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index e72a403..22c1623 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1614,7 +1614,7 @@ static int cb_pcidas_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(cb_pcidas_pci_table) = {
+static const struct pci_device_id cb_pcidas_pci_table[] = {
 	{ PCI_VDEVICE(CB, 0x0001), BOARD_PCIDAS1602_16 },
 	{ PCI_VDEVICE(CB, 0x000f), BOARD_PCIDAS1200 },
 	{ PCI_VDEVICE(CB, 0x0010), BOARD_PCIDAS1602_12 },
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index ff52065..5520b6b 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -4161,7 +4161,7 @@ static int cb_pcidas64_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(cb_pcidas64_pci_table) = {
+static const struct pci_device_id cb_pcidas64_pci_table[] = {
 	{ PCI_VDEVICE(CB, 0x001d), BOARD_PCIDAS6402_16 },
 	{ PCI_VDEVICE(CB, 0x001e), BOARD_PCIDAS6402_12 },
 	{ PCI_VDEVICE(CB, 0x0035), BOARD_PCIDAS64_M1_16 },
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 94f1158..8cca051 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -407,7 +407,7 @@ static int cb_pcidda_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(cb_pcidda_pci_table) = {
+static const struct pci_device_id cb_pcidda_pci_table[] = {
 	{ PCI_VDEVICE(CB, 0x0020), BOARD_DDA02_12 },
 	{ PCI_VDEVICE(CB, 0x0021), BOARD_DDA04_12 },
 	{ PCI_VDEVICE(CB, 0x0022), BOARD_DDA08_12 },
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 30520d4..61ef397 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -288,7 +288,7 @@ static int cb_pcimdas_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(cb_pcimdas_pci_table) = {
+static const struct pci_device_id cb_pcimdas_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0056) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index edf17b6..43a8663 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -206,7 +206,7 @@ static int cb_pcimdda_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(cb_pcimdda_pci_table) = {
+static const struct pci_device_id cb_pcimdda_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CB, PCI_ID_PCIM_DDA06_16) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 89836c0..323a7f3 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -111,7 +111,7 @@ static int contec_pci_dio_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(contec_pci_dio_pci_table) = {
+static const struct pci_device_id contec_pci_dio_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CONTEC, PCI_DEVICE_ID_PIO1616L) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index de920cc..ce153fc 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -772,7 +772,7 @@ static int daqboard2000_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(daqboard2000_pci_table) = {
+static const struct pci_device_id daqboard2000_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_IOTECH, 0x0409) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/das08_pci.c b/drivers/staging/comedi/drivers/das08_pci.c
index 3a6d372..d94af09 100644
--- a/drivers/staging/comedi/drivers/das08_pci.c
+++ b/drivers/staging/comedi/drivers/das08_pci.c
@@ -89,7 +89,7 @@ static int das08_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(das08_pci_table) = {
+static const struct pci_device_id das08_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CB, PCI_DEVICE_ID_PCIDAS08) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 292226e..3dd4a5f 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -818,7 +818,7 @@ static int dt3000_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &dt3000_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(dt3000_pci_table) = {
+static const struct pci_device_id dt3000_pci_table[] = {
 	{ PCI_VDEVICE(DT, 0x0022), BOARD_DT3001 },
 	{ PCI_VDEVICE(DT, 0x0023), BOARD_DT3002 },
 	{ PCI_VDEVICE(DT, 0x0024), BOARD_DT3003 },
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index f2a9f1c..8457bf6 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -260,7 +260,7 @@ static int dyna_pci10xx_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(dyna_pci10xx_pci_table) = {
+static const struct pci_device_id dyna_pci10xx_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_PLX, 0x1050) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index 559bf55..5450bf2 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -914,7 +914,7 @@ static int gsc_hpdi_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &gsc_hpdi_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(gsc_hpdi_pci_table) = {
+static const struct pci_device_id gsc_hpdi_pci_table[] = {
 	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9080, PCI_VENDOR_ID_PLX,
 		    0x2400, 0, 0, 0},
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 1e16641..e00aa90 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -597,7 +597,7 @@ static int icp_multi_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &icp_multi_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(icp_multi_pci_table) = {
+static const struct pci_device_id icp_multi_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ICP, PCI_DEVICE_ID_ICP_MULTI) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index b52d58e..6100c12 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -807,7 +807,7 @@ static int jr3_pci_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &jr3_pci_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(jr3_pci_pci_table) = {
+static const struct pci_device_id jr3_pci_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL_NEW) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_2_CHANNEL) },
diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 15589f6..6b9846f 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -139,7 +139,7 @@ static int ke_counter_pci_probe(struct pci_dev *dev,
 				      id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(ke_counter_pci_table) = {
+static const struct pci_device_id ke_counter_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_KOLTER, CNT_CARD_DEVICE_ID) },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 3d12e91..081a310 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -1635,7 +1635,7 @@ static int me4000_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &me4000_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(me4000_pci_table) = {
+static const struct pci_device_id me4000_pci_table[] = {
 	{ PCI_VDEVICE(MEILHAUS, 0x4650), BOARD_ME4650 },
 	{ PCI_VDEVICE(MEILHAUS, 0x4660), BOARD_ME4660 },
 	{ PCI_VDEVICE(MEILHAUS, 0x4661), BOARD_ME4660I },
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index 24ec9ef..7f66878 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -576,7 +576,7 @@ static int me_daq_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &me_daq_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(me_daq_pci_table) = {
+static const struct pci_device_id me_daq_pci_table[] = {
 	{ PCI_VDEVICE(MEILHAUS, 0x2600), BOARD_ME2600 },
 	{ PCI_VDEVICE(MEILHAUS, 0x2000), BOARD_ME2000 },
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index 85aa960..860fc81 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -455,7 +455,7 @@ static int ni6527_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni6527_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(ni6527_pci_table) = {
+static const struct pci_device_id ni6527_pci_table[] = {
 	{ PCI_VDEVICE(NI, 0x2b10), BOARD_PXI6527 },
 	{ PCI_VDEVICE(NI, 0x2b20), BOARD_PCI6527 },
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 853f62b..5468d0b 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -741,7 +741,7 @@ static int ni_65xx_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni_65xx_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(ni_65xx_pci_table) = {
+static const struct pci_device_id ni_65xx_pci_table[] = {
 	{ PCI_VDEVICE(NI, 0x1710), BOARD_PXI6509 },
 	{ PCI_VDEVICE(NI, 0x7085), BOARD_PCI6509 },
 	{ PCI_VDEVICE(NI, 0x7086), BOARD_PXI6528 },
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 8a991dc..61c64a9 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -1320,7 +1320,7 @@ static int ni_660x_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni_660x_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(ni_660x_pci_table) = {
+static const struct pci_device_id ni_660x_pci_table[] = {
 	{ PCI_VDEVICE(NI, 0x1310), BOARD_PCI6602 },
 	{ PCI_VDEVICE(NI, 0x1360), BOARD_PXI6602 },
 	{ PCI_VDEVICE(NI, 0x2c60), BOARD_PCI6601 },
diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index e4414cf1..8550fdc 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -282,7 +282,7 @@ static int ni_670x_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni_670x_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(ni_670x_pci_table) = {
+static const struct pci_device_id ni_670x_pci_table[] = {
 	{ PCI_VDEVICE(NI, 0x1290), BOARD_PCI6704 },
 	{ PCI_VDEVICE(NI, 0x1920), BOARD_PXI6704 },
 	{ PCI_VDEVICE(NI, 0x2c90), BOARD_PCI6703 },
diff --git a/drivers/staging/comedi/drivers/ni_labpc_pci.c b/drivers/staging/comedi/drivers/ni_labpc_pci.c
index 8be681f..7395970 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_pci.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_pci.c
@@ -107,7 +107,7 @@ static struct comedi_driver labpc_pci_comedi_driver = {
 	.detach		= labpc_pci_detach,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(labpc_pci_table) = {
+static const struct pci_device_id labpc_pci_table[] = {
 	{ PCI_VDEVICE(NI, 0x161), BOARD_NI_PCI1200 },
 	{ 0 }
 };
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index e3a8fa9..8cfd063 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -1200,7 +1200,7 @@ static int ni_pcidio_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni_pcidio_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(ni_pcidio_pci_table) = {
+static const struct pci_device_id ni_pcidio_pci_table[] = {
 	{ PCI_VDEVICE(NI, 0x1150), BOARD_PCIDIO_32HS },
 	{ PCI_VDEVICE(NI, 0x12b0), BOARD_PCI6534 },
 	{ PCI_VDEVICE(NI, 0x1320), BOARD_PXI6533 },
diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 536be83..368a4ad 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1639,7 +1639,7 @@ static int ni_pcimio_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni_pcimio_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(ni_pcimio_pci_table) = {
+static const struct pci_device_id ni_pcimio_pci_table[] = {
 	{ PCI_VDEVICE(NI, 0x0162), BOARD_PCIMIO_16XE_50 },	/* 0x1620? */
 	{ PCI_VDEVICE(NI, 0x1170), BOARD_PCIMIO_16XE_10 },
 	{ PCI_VDEVICE(NI, 0x1180), BOARD_PCIMIO_16E_1 },
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 44c8712..a1e4892e 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1427,7 +1427,7 @@ static int rtd520_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &rtd520_driver, id->driver_data);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(rtd520_pci_table) = {
+static const struct pci_device_id rtd520_pci_table[] = {
 	{ PCI_VDEVICE(RTD, 0x7520), BOARD_DM7520 },
 	{ PCI_VDEVICE(RTD, 0x4520), BOARD_PCI4520 },
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index b486099..6d26623 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2965,7 +2965,7 @@ static int s626_pci_probe(struct pci_dev *dev,
  * also subvendor:subdevice ids, because otherwise it will conflict with
  * Philips SAA7146 media/dvb based cards.
  */
-static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) = {
+static const struct pci_device_id s626_pci_table[] = {
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_PHILIPS, PCI_DEVICE_ID_PHILIPS_SAA7146,
 			 0x6000, 0x0272) },
 	{ 0 }
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index daee2f4..77e2059 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -698,7 +698,7 @@ static int skel_pci_probe(struct pci_dev *dev,
  * This is used by modprobe to translate PCI IDs to drivers.
  * Should only be used for PCI and ISA-PnP devices
  */
-static DEFINE_PCI_DEVICE_TABLE(skel_pci_table) = {
+static const struct pci_device_id skel_pci_table[] = {
 	{ PCI_VDEVICE(SKEL, 0x0100), BOARD_SKEL100 },
 	{ PCI_VDEVICE(SKEL, 0x0200), BOARD_SKEL200 },
 	{ 0 }
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 190b9b9..99eefd0 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -703,7 +703,7 @@ static int chd_dec_pci_resume(struct pci_dev *pdev)
 }
 #endif
 
-static DEFINE_PCI_DEVICE_TABLE(chd_dec_pci_id_table) = {
+static const struct pci_device_id chd_dec_pci_id_table[] = {
 	{ PCI_VDEVICE(BROADCOM, 0x1612), 8 },
 	{ 0, },
 };
diff --git a/drivers/staging/dwc2/pci.c b/drivers/staging/dwc2/pci.c
index 3d14c88..c291fca 100644
--- a/drivers/staging/dwc2/pci.c
+++ b/drivers/staging/dwc2/pci.c
@@ -152,7 +152,7 @@ static int dwc2_driver_probe(struct pci_dev *dev,
 	return retval;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(dwc2_pci_ids) = {
+static const struct pci_device_id dwc2_pci_ids[] = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_SYNOPSYS, PCI_PRODUCT_ID_HAPS_HSOTG),
 	},
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index ab8b29d..ca36b04 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -4930,7 +4930,7 @@ err_disable:
 	goto out;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(et131x_pci_table) = {
+static const struct pci_device_id et131x_pci_table[] = {
 	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_GIG), 0UL},
 	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_FAST), 0UL},
 	{0,}
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 081407b..e729e52 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -974,7 +974,7 @@ dt3155_remove(struct pci_dev *pdev)
 	kfree(pd);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
+static const struct pci_device_id pci_ids[] = {
 	{ PCI_DEVICE(DT3155_VENDOR_ID, DT3155_DEVICE_ID) },
 	{ 0, /* zero marks the end */ },
 };
diff --git a/drivers/staging/media/solo6x10/solo6x10-core.c b/drivers/staging/media/solo6x10/solo6x10-core.c
index 3675020..480b7c4 100644
--- a/drivers/staging/media/solo6x10/solo6x10-core.c
+++ b/drivers/staging/media/solo6x10/solo6x10-core.c
@@ -669,7 +669,7 @@ static void solo_pci_remove(struct pci_dev *pdev)
 	free_solo_dev(solo_dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(solo_id_table) = {
+static const struct pci_device_id solo_id_table[] = {
 	/* 6010 based cards */
 	{ PCI_DEVICE(PCI_VENDOR_ID_SOFTLOGIC, PCI_DEVICE_ID_SOLO6010),
 	  .driver_data = SOLO_DEV_6010 },
diff --git a/drivers/staging/phison/phison.c b/drivers/staging/phison/phison.c
index 919cb95..57fc279 100644
--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -69,7 +69,7 @@ static int phison_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(phison_pci_tbl) = {
+static const struct pci_device_id phison_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_PHISON, PCI_DEVICE_ID_PS5000),
 	  PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 0 },
 	{ 0, },
diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 1e80a40..dca838d 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -4292,7 +4292,7 @@ static void sep_remove(struct pci_dev *pdev)
 }
 
 /* Initialize struct pci_device_id for our driver */
-static DEFINE_PCI_DEVICE_TABLE(sep_pci_id_tbl) = {
+static const struct pci_device_id sep_pci_id_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0826)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x08e9)},
 	{0}
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 652272b..f340cb9 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -136,7 +136,7 @@ MODULE_PARM_DESC(dynamic_intagg, "Dynamic Interrupt Aggregation Setting");
 module_param(intagg_delay, int, 0);
 MODULE_PARM_DESC(intagg_delay, "uSec Interrupt Aggregation Delay");
 
-static DEFINE_PCI_DEVICE_TABLE(slic_pci_tbl) = {
+static const struct pci_device_id slic_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ALACRITECH, SLIC_1GB_DEVICE_ID) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ALACRITECH, SLIC_2GB_DEVICE_ID) },
 	{ 0 }
diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index ba199ff..805c3fa 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -920,7 +920,7 @@ failed_free:
  * 0x712 (LynxEM+)
  * 0x720 (Lynx3DM, Lynx3DM+)
  */
-static DEFINE_PCI_DEVICE_TABLE(smtcfb_pci_table) = {
+static const struct pci_device_id smtcfb_pci_table[] = {
 	{ PCI_DEVICE(0x126f, 0x710), },
 	{ PCI_DEVICE(0x126f, 0x712), },
 	{ PCI_DEVICE(0x126f, 0x720), },
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index e93fdc8..c435198 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -267,7 +267,7 @@ static CHIP_INFO chip_info_table[] = {
 	{0, NULL}
 };
 
-DEFINE_PCI_DEVICE_TABLE(vt6655_pci_id_table) = {
+const struct pci_device_id vt6655_pci_id_table[] = {
 	{ PCI_VDEVICE(VIA, 0x3253), (kernel_ulong_t)chip_info_table},
 	{ 0, }
 };
diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index c033da4..95ce970 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -11,7 +11,7 @@
 #define PCI_DEVICE_ID_XGI_27      0x027
 #endif
 
-static DEFINE_PCI_DEVICE_TABLE(xgifb_pci_table) = {
+static const struct pci_device_id xgifb_pci_table[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_XGI, PCI_DEVICE_ID_XGI_20)},
 	{PCI_DEVICE(PCI_VENDOR_ID_XGI, PCI_DEVICE_ID_XGI_27)},
 	{PCI_DEVICE(PCI_VENDOR_ID_XGI, PCI_DEVICE_ID_XGI_40)},
diff --git a/drivers/staging/xillybus/xillybus_pcie.c b/drivers/staging/xillybus/xillybus_pcie.c
index 1811aa7..0564f97 100644
--- a/drivers/staging/xillybus/xillybus_pcie.c
+++ b/drivers/staging/xillybus/xillybus_pcie.c
@@ -30,7 +30,7 @@ MODULE_LICENSE("GPL v2");
 
 static const char xillyname[] = "xillybus_pcie";
 
-static DEFINE_PCI_DEVICE_TABLE(xillyids) = {
+static const struct pci_device_id xillyids[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, PCI_DEVICE_ID_XILLYBUS)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ALTERA, PCI_DEVICE_ID_XILLYBUS)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ACTEL, PCI_DEVICE_ID_XILLYBUS)},
-- 
1.7.10.4


