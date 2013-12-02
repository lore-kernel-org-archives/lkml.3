Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3LBXYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:24:53 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30576 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3LBXYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:24:49 -0500
X-AuditID: cbfee68f-b7f336d00000481b-c8-529d16bf6a84
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'James E.J. Bottomley'" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 26/39] scsi: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:24:47 +0900
Message-id: <002f01ceefb5$b09bc280$11d34780$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABFMWg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zQ939YnODDO7PtLRoXryezeJS7xJW
	i8sLLwGJXXPYLLqv72BzYPXYP3cNu8fJeT/ZPPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugStj
	+t6FLAVrlCu+L45oYGyV62Lk5JAQMJHYNOUZE4QtJnHh3nq2LkYuDiGBZYwSE+4cZIMpOv51
	GitEYjqjxO9Ju5ggnF+MEvvvXGYBqWITUJP48uUwO4gtImAqsfH9FEaQImaQjuWdn5hBEkIC
	thLTX2wG6ubg4BSwk+j7VAsSFhZwlDjwdDUriM0ioCqx9+wnRhCbF6h83cQ2KFtQ4sfke2C7
	mAW0JNbvPM4EYctLbF7zlhlkpISAusSjv7oQJxhJbFxznxmiRERi34t3YOdICFxjl3g3cwoL
	xC4BiW+TD7FA9MpKbDrADPGwpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnp
	RcZ6xYm5xaV56XrJ+bmbGCHx2b+D8e4B60OMyUDrJzJLiSbnA+M7ryTe0NjMyMLUxNTYyNzS
	jDRhJXHe+w+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw7k4Q1d107Ix/bdTr8+ZuU+f+
	5A/7bJanmrCf8apD9rsTOzeeM5v3+0VFtbvN1rcSUbqrF3Tsf3JJyLzGQ+tXuaRxYde+aad2
	6xatm/p1075DhXPSV807ZWf1O+Xkot2RfVN+dvplpYkaxCyw/vRN+tHz8rOpD24qKPDNYGK4
	eHqj23Xvyxc231BiKc5INNRiLipOBAD+nc8j5QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd39YnODDF6+N7FoXryezeJS7xJW
	i8sLLwGJXXPYLLqv72BzYPXYP3cNu8fJeT/ZPPq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdosZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsI4xY/rehSwFa5Qrvi+OaGBsleti5OSQEDCROP51GiuELSZx
	4d56ti5GLg4hgemMEr8n7WKCcH4xSuy/c5kFpIpNQE3iy5fD7CC2iICpxMb3UxhBiphBOpZ3
	fmIGSQgJ2EpMf7EZqJuDg1PATqLvUy1IWFjAUeLA09Vg21gEVCX2nv3ECGLzApWvm9gGZQtK
	/Jh8D2wXs4CWxPqdx5kgbHmJzWveMoOMlBBQl3j0VxfiBCOJjWvuM0OUiEjse/GOcQKj0Cwk
	k2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO/mdSOxhXNlgcYhTg
	YFTi4X2wfU6QEGtiWXFl7iFGCQ5mJRHeTp65QUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqc
	D0xMeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAGL17ZqgO
	7wElq6V3GSRXyzwt+rTOglXzpPX6hs9inXeZ09+e3jr/OH+l1GLvg0ulD344uO/OmV2RqU9P
	2BUucPixxU7/yguWf/7/jpU1iXovdTH6++1t3k6u94+uRZ9qO/O57PcOqTV3P95L8XeNWRTp
	euL+5ZXzvAorSgKMvU+d6vHbtej6XRElluKMREMt5qLiRADVmVfVQgMAAA==
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
 drivers/scsi/BusLogic.c              |    2 +-
 drivers/scsi/be2iscsi/be_main.c      |    2 +-
 drivers/scsi/csiostor/csio_init.c    |    2 +-
 drivers/scsi/isci/init.c             |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    2 +-
 drivers/scsi/mvumi.c                 |    2 +-
 drivers/scsi/ufs/ufshcd-pci.c        |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 972f817..64c7514 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3893,7 +3893,7 @@ __setup("BusLogic=", blogic_setup);
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
 };*/
-static DEFINE_PCI_DEVICE_TABLE(blogic_pci_tbl) = {
+static const struct pci_device_id blogic_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT)},
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1f37505..1f1f39d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -534,7 +534,7 @@ static umode_t beiscsi_eth_get_attr_visibility(void *data, int type)
 }
 
 /*------------------- PCI Driver operations and data ----------------- */
-static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {
+static const struct pci_device_id beiscsi_pci_id_table[] = {
 	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
 	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID2) },
 	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID1) },
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 1aafc33..17794ad 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1167,7 +1167,7 @@ static struct pci_error_handlers csio_err_handler = {
 	.resume		= csio_pci_resume,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(csio_pci_tbl) = {
+static const struct pci_device_id csio_pci_tbl[] = {
 	CSIO_DEVICE(CSIO_DEVID_T440DBG_FCOE, 0),        /* T4 DEBUG FCOE */
 	CSIO_DEVICE(CSIO_DEVID_T420CR_FCOE, 0),		/* T420CR FCOE */
 	CSIO_DEVICE(CSIO_DEVID_T422CR_FCOE, 0),		/* T422CR FCOE */
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index d25d0d8..c457138 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -75,7 +75,7 @@ MODULE_VERSION(DRV_VERSION);
 
 static struct scsi_transport_template *isci_transport_template;
 
-static DEFINE_PCI_DEVICE_TABLE(isci_id_table) = {
+static const struct pci_device_id isci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, 0x1D61),},
 	{ PCI_VDEVICE(INTEL, 0x1D63),},
 	{ PCI_VDEVICE(INTEL, 0x1D65),},
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a961fe1..2834108 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -247,7 +247,7 @@ struct _scsi_io_transfer {
 /*
  * The pci device ids are defined in mpi/mpi2_cnfg.h.
  */
-static DEFINE_PCI_DEVICE_TABLE(scsih_pci_table) = {
+static const struct pci_device_id scsih_pci_table[] = {
 	/* Fury ~ 3004 and 3008 */
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3004,
 		PCI_ANY_ID, PCI_ANY_ID },
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index edbee8d..27e5986 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -48,7 +48,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("jyli@marvell.com");
 MODULE_DESCRIPTION("Marvell UMI Driver");
 
-static DEFINE_PCI_DEVICE_TABLE(mvumi_pci_table) = {
+static const struct pci_device_id mvumi_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, PCI_DEVICE_ID_MARVELL_MV9143) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, PCI_DEVICE_ID_MARVELL_MV9580) },
 	{ 0 }
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 8b95312..ff1f0c3 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -211,7 +211,7 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
 	.runtime_idle    = ufshcd_pci_runtime_idle,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(ufshcd_pci_tbl) = {
+static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ }	/* terminate list */
 };
-- 
1.7.10.4


