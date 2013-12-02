Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3LBXLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:11:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:28526 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3LBXLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:11:21 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-6c-529d139888a3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Wolfram Sang'" <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 11/39] i2c: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:11:20 +0900
Message-id: <002001ceefb3$cfb652e0$6f22f8a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAmtrg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zY90ZwnODDJb/VrZoXryezeLywkus
	Fh1/vzBaXN41h81i5YlZzA6sHvvnrmH36NuyitHj5KknLB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZayZdJetYFpMxatnGxgbGJv9uhg5OSQETCSOPD3GCmGLSVy4t56ti5GLQ0hgGaPE+W0dzF2M
	HGBFn3+UQMQXMUo8mPCDEcL5xSgx7WMDO0g3m4CaxJcvh8FsEQFTiY3vp4AVMQu0Mkpsa9vM
	CJIQErCVmP5iMxPIVE4BO4m+T7UgYWEBB4mFDxrArmARUJVY8P4yWDkvUPmCa1eYIGxBiR+T
	77GA2MwCWhLrdx5ngrDlJTaveQt1qLrEo7+6ECcYSUza85wRokREYt+Ld2DnSAhcY5eY/uYU
	M8QuAYlvkw+xQPTKSmw6wAwJCEmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT
	0ouM9IoTc4tL89L1kvNzNzFC4rNvB+PNA9aHGJOB1k9klhJNzgfGd15JvKGxmZGFqYmpsZG5
	pRlpwkrivIseJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYIz2LOmYOdm0zaet1PBRnMxm
	3+98Pj8YRTj/sHnKbOu6tnzilA+L2S8F39z61KlPwXThdt3nxo3bL174Wv6f96aoxF57O6VV
	3Wcjyla9PrCXJWV/cNO1tWv5ZhUF3Ur6/HE2l/yCWVvlolxTeA9d7NQ7tdc/cY997DSln5oC
	a1cd7fgaylAdFabEUpyRaKjFXFScCAAJpzQu5QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jAd0ZwnODDHbvkLNoXryezeLywkus
	Fh1/vzBaXN41h81i5YlZzA6sHvvnrmH36NuyitHj5KknLB6fN8kFsEQ1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1WUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMWasmXSXrWBaTMWrZxsYGxib/boYOTgkBEwkPv8o6WLk
	BDLFJC7cW8/WxcjFISSwiFHiwYQfjBDOL0aJaR8b2EGq2ATUJL58OQxmiwiYSmx8PwWsiFmg
	lVFiW9tmRpCEkICtxPQXm5lANnAK2En0faoFCQsLOEgsfNDACmKzCKhKLHh/GaycF6h8wbUr
	TBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlhjhaXeLRX12IE4wkJu15zghRIiKx78U7xgmM
	QrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4+p9J7WBc2WBx
	iFGAg1GJh/fB9jlBQqyJZcWVuYcYJTiYlUR4O3nmBgnxpiRWVqUW5ccXleakFh9iTAZ6dCKz
	lGhyPjAx5ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY8nV
	d9b3A+5Ou/hxp8/BoGArm6XvUh/+vZe66TWj+g6OnXvUN/5W4JOLEYmOOLSPn286z0qzBb+i
	uL4+OKl3b653uMCP+6ud9Zboupzn++h9JMxvjqJVgkxunXjIjS9W53d94Er/zL/O77tp5Grm
	n4sKjbVWLEp959OmwFTx47frpYbLgsk8+kosxRmJhlrMRcWJAGGQqmlCAwAA
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
 drivers/i2c/busses/i2c-ali1535.c           |    2 +-
 drivers/i2c/busses/i2c-ali1563.c           |    2 +-
 drivers/i2c/busses/i2c-ali15x3.c           |    2 +-
 drivers/i2c/busses/i2c-amd756.c            |    2 +-
 drivers/i2c/busses/i2c-amd8111.c           |    2 +-
 drivers/i2c/busses/i2c-designware-pcidrv.c |    2 +-
 drivers/i2c/busses/i2c-eg20t.c             |    2 +-
 drivers/i2c/busses/i2c-hydra.c             |    2 +-
 drivers/i2c/busses/i2c-i801.c              |    2 +-
 drivers/i2c/busses/i2c-ismt.c              |    2 +-
 drivers/i2c/busses/i2c-nforce2.c           |    2 +-
 drivers/i2c/busses/i2c-pasemi.c            |    2 +-
 drivers/i2c/busses/i2c-piix4.c             |    2 +-
 drivers/i2c/busses/i2c-pxa-pci.c           |    2 +-
 drivers/i2c/busses/i2c-sis5595.c           |    2 +-
 drivers/i2c/busses/i2c-sis630.c            |    2 +-
 drivers/i2c/busses/i2c-sis96x.c            |    2 +-
 drivers/i2c/busses/i2c-via.c               |    2 +-
 drivers/i2c/busses/i2c-viapro.c            |    2 +-
 drivers/i2c/busses/scx200_acb.c            |    2 +-
 20 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ali1535.c b/drivers/i2c/busses/i2c-ali1535.c
index 3f49181..00b5f00 100644
--- a/drivers/i2c/busses/i2c-ali1535.c
+++ b/drivers/i2c/busses/i2c-ali1535.c
@@ -495,7 +495,7 @@ static struct i2c_adapter ali1535_adapter = {
 	.algo		= &smbus_algorithm,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(ali1535_ids) = {
+static const struct pci_device_id ali1535_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ },
 };
diff --git a/drivers/i2c/busses/i2c-ali1563.c b/drivers/i2c/busses/i2c-ali1563.c
index 84ccd94..5c8174e 100644
--- a/drivers/i2c/busses/i2c-ali1563.c
+++ b/drivers/i2c/busses/i2c-ali1563.c
@@ -417,7 +417,7 @@ static void ali1563_remove(struct pci_dev *dev)
 	ali1563_shutdown(dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(ali1563_id_table) = {
+static const struct pci_device_id ali1563_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1563) },
 	{},
 };
diff --git a/drivers/i2c/busses/i2c-ali15x3.c b/drivers/i2c/busses/i2c-ali15x3.c
index 26bcc61..735758b 100644
--- a/drivers/i2c/busses/i2c-ali15x3.c
+++ b/drivers/i2c/busses/i2c-ali15x3.c
@@ -477,7 +477,7 @@ static struct i2c_adapter ali15x3_adapter = {
 	.algo		= &smbus_algorithm,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(ali15x3_ids) = {
+static const struct pci_device_id ali15x3_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-amd756.c b/drivers/i2c/busses/i2c-amd756.c
index e13e2aa..99f6d98 100644
--- a/drivers/i2c/busses/i2c-amd756.c
+++ b/drivers/i2c/busses/i2c-amd756.c
@@ -308,7 +308,7 @@ static const char* chipname[] = {
 	"nVidia nForce", "AMD8111",
 };
 
-static DEFINE_PCI_DEVICE_TABLE(amd756_ids) = {
+static const struct pci_device_id amd756_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_VIPER_740B),
 	  .driver_data = AMD756 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_VIPER_7413),
diff --git a/drivers/i2c/busses/i2c-amd8111.c b/drivers/i2c/busses/i2c-amd8111.c
index a44e6e7..e82c258 100644
--- a/drivers/i2c/busses/i2c-amd8111.c
+++ b/drivers/i2c/busses/i2c-amd8111.c
@@ -415,7 +415,7 @@ static const struct i2c_algorithm smbus_algorithm = {
 };
 
 
-static DEFINE_PCI_DEVICE_TABLE(amd8111_ids) = {
+static const struct pci_device_id amd8111_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8111_SMBUS2) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index f6ed06c..1d3b4eb 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -309,7 +309,7 @@ static void i2c_dw_pci_remove(struct pci_dev *pdev)
 /* work with hotplug and coldplug */
 MODULE_ALIAS("i2c_designware-pci");
 
-static DEFINE_PCI_DEVICE_TABLE(i2_designware_pci_ids) = {
+static const struct pci_device_id i2_designware_pci_ids[] = {
 	/* Moorestown */
 	{ PCI_VDEVICE(INTEL, 0x0802), moorestown_0 },
 	{ PCI_VDEVICE(INTEL, 0x0803), moorestown_1 },
diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index ff15ae9..675e040 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -187,7 +187,7 @@ static DEFINE_MUTEX(pch_mutex);
 #define PCI_DEVICE_ID_ML7223_I2C	0x8010
 #define PCI_DEVICE_ID_ML7831_I2C	0x8817
 
-static DEFINE_PCI_DEVICE_TABLE(pch_pcidev_id) = {
+static const struct pci_device_id pch_pcidev_id[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_PCH_I2C),   1, },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_I2C), 2, },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_I2C), 1, },
diff --git a/drivers/i2c/busses/i2c-hydra.c b/drivers/i2c/busses/i2c-hydra.c
index 79c3d90..eef07b3 100644
--- a/drivers/i2c/busses/i2c-hydra.c
+++ b/drivers/i2c/busses/i2c-hydra.c
@@ -105,7 +105,7 @@ static struct i2c_adapter hydra_adap = {
 	.algo_data	= &hydra_bit_data,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(hydra_ids) = {
+static const struct pci_device_id hydra_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, PCI_DEVICE_ID_APPLE_HYDRA) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 737e298..9adae45 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -789,7 +789,7 @@ static const struct i2c_algorithm smbus_algorithm = {
 	.functionality	= i801_func,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
+static const struct pci_device_id i801_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AA_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AB_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_2) },
diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index 0043ede..cc271d9 100644
--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -183,7 +183,7 @@ struct ismt_priv {
 /**
  * ismt_ids - PCI device IDs supported by this driver
  */
-static DEFINE_PCI_DEVICE_TABLE(ismt_ids) = {
+static const struct pci_device_id ismt_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_S1200_SMT0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_S1200_SMT1) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_AVOTON_SMT) },
diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
index ac88f40..caa5568 100644
--- a/drivers/i2c/busses/i2c-nforce2.c
+++ b/drivers/i2c/busses/i2c-nforce2.c
@@ -307,7 +307,7 @@ static struct i2c_algorithm smbus_algorithm = {
 };
 
 
-static DEFINE_PCI_DEVICE_TABLE(nforce2_ids) = {
+static const struct pci_device_id nforce2_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2S_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE3_SMBUS) },
diff --git a/drivers/i2c/busses/i2c-pasemi.c b/drivers/i2c/busses/i2c-pasemi.c
index 615f632..7a9dce4 100644
--- a/drivers/i2c/busses/i2c-pasemi.c
+++ b/drivers/i2c/busses/i2c-pasemi.c
@@ -401,7 +401,7 @@ static void pasemi_smb_remove(struct pci_dev *dev)
 	kfree(smbus);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pasemi_smb_ids) = {
+static const struct pci_device_id pasemi_smb_ids[] = {
 	{ PCI_DEVICE(0x1959, 0xa003) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index a028617..b0228a4 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -522,7 +522,7 @@ static const struct i2c_algorithm smbus_algorithm = {
 	.functionality	= piix4_func,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
+static const struct pci_device_id piix4_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443MX_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_EFAR, PCI_DEVICE_ID_EFAR_SLC90E66_3) },
diff --git a/drivers/i2c/busses/i2c-pxa-pci.c b/drivers/i2c/busses/i2c-pxa-pci.c
index 9639be8..417464e 100644
--- a/drivers/i2c/busses/i2c-pxa-pci.c
+++ b/drivers/i2c/busses/i2c-pxa-pci.c
@@ -148,7 +148,7 @@ static void ce4100_i2c_remove(struct pci_dev *dev)
 	kfree(sds);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(ce4100_i2c_devices) = {
+static const struct pci_device_id ce4100_i2c_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2e68)},
 	{ },
 };
diff --git a/drivers/i2c/busses/i2c-sis5595.c b/drivers/i2c/busses/i2c-sis5595.c
index 79fd96a..ac9bc33 100644
--- a/drivers/i2c/busses/i2c-sis5595.c
+++ b/drivers/i2c/busses/i2c-sis5595.c
@@ -369,7 +369,7 @@ static struct i2c_adapter sis5595_adapter = {
 	.algo		= &smbus_algorithm,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(sis5595_ids) = {
+static const struct pci_device_id sis5595_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_503) }, 
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-sis630.c b/drivers/i2c/busses/i2c-sis630.c
index 36a9556..d8adf96 100644
--- a/drivers/i2c/busses/i2c-sis630.c
+++ b/drivers/i2c/busses/i2c-sis630.c
@@ -511,7 +511,7 @@ static struct i2c_adapter sis630_adapter = {
 	.retries	= 3
 };
 
-static DEFINE_PCI_DEVICE_TABLE(sis630_ids) = {
+static const struct pci_device_id sis630_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_503) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_LPC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_964) },
diff --git a/drivers/i2c/busses/i2c-sis96x.c b/drivers/i2c/busses/i2c-sis96x.c
index b9faf9b..56c2443 100644
--- a/drivers/i2c/busses/i2c-sis96x.c
+++ b/drivers/i2c/busses/i2c-sis96x.c
@@ -245,7 +245,7 @@ static struct i2c_adapter sis96x_adapter = {
 	.algo		= &smbus_algorithm,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(sis96x_ids) = {
+static const struct pci_device_id sis96x_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_SMBUS) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-via.c b/drivers/i2c/busses/i2c-via.c
index be66251..9860c64 100644
--- a/drivers/i2c/busses/i2c-via.c
+++ b/drivers/i2c/busses/i2c-via.c
@@ -89,7 +89,7 @@ static struct i2c_adapter vt586b_adapter = {
 };
 
 
-static DEFINE_PCI_DEVICE_TABLE(vt586b_ids) = {
+static const struct pci_device_id vt586b_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_3) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-viapro.c b/drivers/i2c/busses/i2c-viapro.c
index b2d90e1..42aa27a 100644
--- a/drivers/i2c/busses/i2c-viapro.c
+++ b/drivers/i2c/busses/i2c-viapro.c
@@ -442,7 +442,7 @@ release_region:
 	return error;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(vt596_ids) = {
+static const struct pci_device_id vt596_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C596_3),
 	  .driver_data = SMBBA1 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C596B_3),
diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
index 2d1d2c5..cb66f95 100644
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -556,7 +556,7 @@ static struct platform_driver scx200_pci_driver = {
 	.remove = scx200_remove,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(scx200_isa) = {
+static const struct pci_device_id scx200_isa[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SCx200_BRIDGE) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SC1100_BRIDGE) },
 	{ 0, }
-- 
1.7.10.4


