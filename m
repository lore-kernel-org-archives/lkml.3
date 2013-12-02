Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3LBXID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:08:03 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:28021 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3LBXH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:07:59 -0500
X-AuditID: cbfee691-b7f666d0000048b0-38-529d12ce8b79
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Doug Thompson'" <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 07/39] edac: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:07:57 +0900
Message-id: <001c01ceefb3$5724d860$056e8920$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAbvhw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zQ91zQnODDC5tkrS4uuwsk0Xz4vVs
	FpcXXmK1uHCqgcni8q45bA6sHvvnrmH36NuyitHj8yY5jymH2lkCWKK4bFJSczLLUov07RK4
	Ml6fXsJa8MevYvGEt0wNjNeduhg5OSQETCRWPt/NCmGLSVy4t54NxBYSWMYo8XKFN0zNk7lr
	gOJcQPHpjBIPe+4wQzi/GCW6f+9gAqliE1CT+PLlMDuILSJgKrHx/RRGkCJmgX5GiY+b9zFB
	jLWVmP5iM5DNwcEpYCfR96kWJCws4CjR/ns7C4jNIqAq8bZhKpjNC1TefHEDO4QtKPFj8j2w
	OLOAlsT6nceZIGx5ic1r3jKDjJQQUJd49FcX4gQjiftHPkGVi0jse/EO7BwJgWvsEg/XfIDa
	JSDxbfIhFoheWYlNB5ghHpaUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3I
	VK84Mbe4NC9dLzk/dxMjJD4n7mC8f8D6EGMy0PqJzFKiyfnA+M4riTc0NjOyMDUxNTYytzQj
	TVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsadMx2iBQ91nn+lkK8Sv+SnVdtn
	RQmVqfe4wtd8mKBczs4XXGKflWi8YCP3R48piffU1Vc3Xqx9v3K1pltfj8Ye52sbahbE1Two
	2+zqcnSdq561ifqnAqY1NpMqYvuiS271LyrZw8q+S8LdOMfn3jzuxbudIj5xX9eYXq2/ZKOx
	rqJl4wzhe0osxRmJhlrMRcWJAHsHSKDlAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQd1zQnODDCZ/Fba4uuwsk0Xz4vVs
	FpcXXmK1uHCqgcni8q45bA6sHvvnrmH36NuyitHj8yY5jymH2lkCWKIaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwnrGDNen17CWvDHr2LxhLdMDYzXnboYOTkkBEwknsxdwwZh
	i0lcuLceyObiEBKYzijxsOcOM4Tzi1Gi+/cOJpAqNgE1iS9fDrOD2CICphIb309hBCliFuhn
	lPi4eR9YkZCArcT0F5uBbA4OTgE7ib5PtSBhYQFHifbf21lAbBYBVYm3DVPBbF6g8uaLG9gh
	bEGJH5PvgcWZBbQk1u88zgRhy0tsXvOWGWSkhIC6xKO/uhAnGEncP/IJqlxEYt+Ld4wTGIVm
	IZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcPw/k9rBuLLB4hCj
	AAejEg/vg+1zgoRYE8uKK3MPMUpwMCuJ8HbyzA0S4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR
	5HxgasoriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsbJ4rGz
	OyNe7T14alXT3EsTPQ88m3RMY/O6g9YPTXeZ3A7P23P/4v7CKrmpPjz3NQPvR2QslZNt2x04
	1ez6tcQnxadPPC3rYit9yb77zwkHZZEVi1daZq1xdL154cCnTbab92XG3J52Y46ymNPbk3Zb
	t7y70/H8t/NiJQMOeTN1ucWlh8XlQn7sUGIpzkg01GIuKk4EAJFwwFNDAwAA
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
 drivers/edac/amd64_edac.c      |    2 +-
 drivers/edac/amd76x_edac.c     |    2 +-
 drivers/edac/e752x_edac.c      |    2 +-
 drivers/edac/e7xxx_edac.c      |    2 +-
 drivers/edac/i3000_edac.c      |    2 +-
 drivers/edac/i3200_edac.c      |    2 +-
 drivers/edac/i5000_edac.c      |    2 +-
 drivers/edac/i5100_edac.c      |    2 +-
 drivers/edac/i5400_edac.c      |    2 +-
 drivers/edac/i7300_edac.c      |    2 +-
 drivers/edac/i7core_edac.c     |    2 +-
 drivers/edac/i82443bxgx_edac.c |    2 +-
 drivers/edac/i82860_edac.c     |    2 +-
 drivers/edac/i82875p_edac.c    |    2 +-
 drivers/edac/i82975x_edac.c    |    2 +-
 drivers/edac/r82600_edac.c     |    2 +-
 drivers/edac/sb_edac.c         |    2 +-
 drivers/edac/x38_edac.c        |    2 +-
 18 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index b53d0de..b43c42d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2795,7 +2795,7 @@ static void amd64_remove_one_instance(struct pci_dev *pdev)
  * PCI core identifies what devices are on a system during boot, and then
  * inquiry this table to see if this driver is for a given device found.
  */
-static DEFINE_PCI_DEVICE_TABLE(amd64_pci_table) = {
+static const struct pci_device_id amd64_pci_table[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_AMD,
 		.device		= PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index 96e3ee3..3a501b5 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -333,7 +333,7 @@ static void amd76x_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(amd76x_pci_tbl) = {
+static const struct pci_device_id amd76x_pci_tbl[] = {
 	{
 	 PCI_VEND_DEV(AMD, FE_GATE_700C), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 AMD762},
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 644fec5..5fb01b0 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1421,7 +1421,7 @@ static void e752x_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(e752x_pci_tbl) = {
+static const struct pci_device_id e752x_pci_tbl[] = {
 	{
 	 PCI_VEND_DEV(INTEL, 7520_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 E7520},
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 1c4056a..3cda79b 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -555,7 +555,7 @@ static void e7xxx_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(e7xxx_pci_tbl) = {
+static const struct pci_device_id e7xxx_pci_tbl[] = {
 	{
 	 PCI_VEND_DEV(INTEL, 7205_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 E7205},
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index 694efcb..cd28b96 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -487,7 +487,7 @@ static void i3000_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(i3000_pci_tbl) = {
+static const struct pci_device_id i3000_pci_tbl[] = {
 	{
 	 PCI_VEND_DEV(INTEL, 3000_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 I3000},
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index be10a74..fa1326e 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -466,7 +466,7 @@ static void i3200_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(i3200_pci_tbl) = {
+static const struct pci_device_id i3200_pci_tbl[] = {
 	{
 		PCI_VEND_DEV(INTEL, 3200_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		I3200},
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 63b2194..72e07e3 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1530,7 +1530,7 @@ static void i5000_remove_one(struct pci_dev *pdev)
  *
  *	The "E500P" device is the first device supported.
  */
-static DEFINE_PCI_DEVICE_TABLE(i5000_pci_tbl) = {
+static const struct pci_device_id i5000_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_I5000_DEV16),
 	 .driver_data = I5000P},
 
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 157b934..36a38ee 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -1213,7 +1213,7 @@ static void i5100_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(i5100_pci_tbl) = {
+static const struct pci_device_id i5100_pci_tbl[] = {
 	/* Device 16, Function 0, Channel 0 Memory Map, Error Flag/Mask, ... */
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5100_16) },
 	{ 0, }
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 0a05bbc..e080cbf 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1416,7 +1416,7 @@ static void i5400_remove_one(struct pci_dev *pdev)
  *
  *	The "E500P" device is the first device supported.
  */
-static DEFINE_PCI_DEVICE_TABLE(i5400_pci_tbl) = {
+static const struct pci_device_id i5400_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR)},
 	{0,}			/* 0 terminated list. */
 };
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 9004c64..d63f479 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -1160,7 +1160,7 @@ static void i7300_remove_one(struct pci_dev *pdev)
  *
  * Has only 8086:360c PCI ID
  */
-static DEFINE_PCI_DEVICE_TABLE(i7300_pci_tbl) = {
+static const struct pci_device_id i7300_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_I7300_MCH_ERR)},
 	{0,}			/* 0 terminated list. */
 };
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 80a963d..87533ca 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -394,7 +394,7 @@ static const struct pci_id_table pci_dev_table[] = {
 /*
  *	pci_device_id	table for which devices we are looking for
  */
-static DEFINE_PCI_DEVICE_TABLE(i7core_pci_tbl) = {
+static const struct pci_device_id i7core_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_X58_HUB_MGMT)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNNFIELD_QPI_LINK0)},
 	{0,}			/* 0 terminated list. */
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 57fdb77..d730e276 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -386,7 +386,7 @@ static void i82443bxgx_edacmc_remove_one(struct pci_dev *pdev)
 
 EXPORT_SYMBOL_GPL(i82443bxgx_edacmc_remove_one);
 
-static DEFINE_PCI_DEVICE_TABLE(i82443bxgx_pci_tbl) = {
+static const struct pci_device_id i82443bxgx_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443BX_0)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443BX_2)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443GX_0)},
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 3e3e431..3382f63 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -288,7 +288,7 @@ static void i82860_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(i82860_pci_tbl) = {
+static const struct pci_device_id i82860_pci_tbl[] = {
 	{
 	 PCI_VEND_DEV(INTEL, 82860_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 I82860},
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 2f8535f..80573df 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -527,7 +527,7 @@ static void i82875p_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(i82875p_pci_tbl) = {
+static const struct pci_device_id i82875p_pci_tbl[] = {
 	{
 	 PCI_VEND_DEV(INTEL, 82875_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 I82875P},
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 0c8d4b0..10b1052 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -628,7 +628,7 @@ static void i82975x_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(i82975x_pci_tbl) = {
+static const struct pci_device_id i82975x_pci_tbl[] = {
 	{
 		PCI_VEND_DEV(INTEL, 82975_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		I82975X
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index 2fd6a54..8f936bc 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -383,7 +383,7 @@ static void r82600_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(r82600_pci_tbl) = {
+static const struct pci_device_id r82600_pci_tbl[] = {
 	{
 	 PCI_DEVICE(PCI_VENDOR_ID_RADISYS, R82600_BRIDGE_ID)
 	 },
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 8472405..b5d254b 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -461,7 +461,7 @@ static const struct pci_id_table pci_dev_descr_ibridge_table[] = {
 /*
  *	pci_device_id	table for which devices we are looking for
  */
-static DEFINE_PCI_DEVICE_TABLE(sbridge_pci_tbl) = {
+static const struct pci_device_id sbridge_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TA)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IBRIDGE_IMC_HA0_TA)},
 	{0,}			/* 0 terminated list. */
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 1a4df82..4891b45 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -448,7 +448,7 @@ static void x38_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(x38_pci_tbl) = {
+static const struct pci_device_id x38_pci_tbl[] = {
 	{
 	 PCI_VEND_DEV(INTEL, X38_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 X38},
-- 
1.7.10.4


