Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3LBXQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:16:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12198 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3LBXQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:16:46 -0500
X-AuditID: cbfee690-b7f126d00000418c-f8-529d14d9a9be
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 17/39] misc: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:16:41 +0900
Message-id: <002601ceefb4$8f005b00$ad011100$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAyP9g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zY92bInODDFY9k7VoXryezeLywkus
	Fpd3zWFzYPbYP3cNu0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlTLnby1Swj7+i/cwn5gbG
	xbxdjJwcEgImEl9+/WGDsMUkLtxbD2RzcQgJLGOUWHLzMzNM0dSeKywQiUWMEjeOLGWEcH4x
	Smx6d58FpIpNQE3iy5fD7CC2iICpxMb3U4CKODiYBVwkjk4TAQkLCdhKTH+xmQkkzClgJ9H3
	qRYkLCzgKHH+8xdWEJtFQFViwZlfbCAlvEDlPce5QcK8AoISPybfA1vELKAlsX7ncSYIW15i
	85q3zCDlEgLqEo/+6kLsN5LoW7maEaJERGLfi3dgB0sIHGKXWP3pLwvEKgGJb5MPsUD0ykps
	OgD1raTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UUmesWJucWleel6yfm5
	mxgh0TdhB+O9A9aHGJOB1k9klhJNzgdGb15JvKGxmZGFqYmpsZG5pRlpwkrivGqPkoKEBNIT
	S1KzU1MLUovii0pzUosPMTJxcEo1MDq88/tj3pUjdHJC0Amb8CDO7yXtoTcClq1ldF7L6nXp
	9RHVWr2oDdmnhVzETl0z3r2iqEyR/flCxWqPJqZ1kZ0W/OnXRRmc1s9pOK3DFeZ182lN+2/X
	A8LqOSxp+lb2DeHV528GdrrMe8p8c+fOA5N2a4k/sxAIYevdEOW/PkZ291Ku9WwrlViKMxIN
	tZiLihMB1caJRNQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd2bInODDDpnSFk0L17PZnF54SVW
	i8u75rA5MHvsn7uG3aNvyypGj8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCesYM6bc7WUq2Mdf0X7mE3MD42LeLkZODgkBE4mpPVdYIGwxiQv31rN1MXJxCAksYpS4
	cWQpI4Tzi1Fi07v7YFVsAmoSX74cZgexRQRMJTa+nwJUxMHBLOAicXSaCEhYSMBWYvqLzUwg
	YU4BO4m+T7UgYWEBR4nzn7+wgtgsAqoSC878YgMp4QUq7znODRLmFRCU+DH5HtgiZgEtifU7
	jzNB2PISm9e8ZQYplxBQl3j0Vxdiv5FE38rVjBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYF
	jCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJj+5nUDsaVDRaHGAU4GJV4eB9snxMkxJpY
	VlyZe4hRgoNZSYS3k2dukBBvSmJlVWpRfnxRaU5q8SHGZKA/JzJLiSbnA9NOXkm8obGJmZGl
	kZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUw6ns+/ye/n+P/k2J/y5dvN6hV
	Gf/QuioW9TCp4J1E5BNnt7k/Lvk/M5lgftnjlLNmqFKKzOVLGX8fd/h6NnWtPzbtl2B/2tXW
	OTaXFwXJ+My31T+tJV7P5HkhLUxt5bQtW1Jlaz0i/lTdKjV7uXLbzN9eEuGPPKMuyyjYKR+K
	+pT/b1ebosM7JZbijERDLeai4kQAvPhQETEDAAA=
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
 drivers/misc/mei/pci-me.c          |    2 +-
 drivers/misc/mic/host/mic_main.c   |    2 +-
 drivers/misc/vmw_vmci/vmci_guest.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index b96205a..ff5f68c 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -44,7 +44,7 @@
 #include "client.h"
 
 /* mei_pci_tbl - PCI Device ID Table */
-static DEFINE_PCI_DEVICE_TABLE(mei_me_pci_tbl) = {
+static const struct pci_device_id mei_me_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82946GZ)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G35)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82Q965)},
diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_main.c
index ad838c7..0ae90a4 100644
--- a/drivers/misc/mic/host/mic_main.c
+++ b/drivers/misc/mic/host/mic_main.c
@@ -38,7 +38,7 @@
 
 static const char mic_driver_name[] = "mic";
 
-static DEFINE_PCI_DEVICE_TABLE(mic_pci_tbl) = {
+static const struct pci_device_id mic_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2250)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2251)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2252)},
diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index c98b03b..9d8a116 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -745,7 +745,7 @@ static void vmci_guest_remove_device(struct pci_dev *pdev)
 	/* The rest are managed resources and will be freed by PCI core */
 }
 
-static DEFINE_PCI_DEVICE_TABLE(vmci_ids) = {
+static const struct pci_device_id vmci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VMWARE, PCI_DEVICE_ID_VMWARE_VMCI), },
 	{ 0 },
 };
-- 
1.7.10.4


