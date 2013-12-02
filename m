Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3LBX2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:28:03 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:31019 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3LBX17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:27:59 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-50-529d177e0410
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        linux-usb@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 31/39] USB: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:27:58 +0900
Message-id: <003401ceefb6$22c930e0$685b92a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABMH6A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zY9068blBBnf7LSyaF69ns7i88BKr
	xeVdc9gsFi1rZXZg8dg/dw27R9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGV0TzvHWvBXrGL5
	1OIGxo3CXYycHBICJhKXfhxnhbDFJC7cW8/WxcjFISSwjFHiwtplTDBFS07fgkosYpTo/3id
	CcL5xShx8dw3NpAqNgE1iS9fDrOD2CICphIb309hBLGZBRIlvt0/DlYjJGArMf3FZqBmDg5O
	ATuJvk+1IGFhAQeJ6z0Lwa5gEVCV+Hz7LzOIzQtUfuHYO0YIW1Dix+R7LBAjtSTW7zzOBGHL
	S2xe85YZZKSEgLrEo7+6EBcYSay5OR2qRERi3wuQMVxAJYfYJfb+6GWG2CUg8W3yIRaIXlmJ
	TQeYIf6VlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yFCvODG3uDQvXS85
	P3cTIyQSe3cw3j5gfYgxGWj9RGYp0eR8YCTnlcQbGpsZWZiamBobmVuakSasJM6b9DApSEgg
	PbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjlOP25/y1j7oksOY1HHr4ercq3851NgypdeVnVaWr
	DVPWbzKtmWwr5VEnELJYXiZtd6q59eU29qa0SROfNMTPidMXaBe+5m+/s/Xe7KqPt4yez32X
	r5Bx7q+ald5t38PMtf3dP+6YGF+ufVX8udD83fbpS2VPlhReMt4+PXLh6+fJNv1H3HqUWIoz
	Eg21mIuKEwHZALeX2gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd068blBBjfeGVs0L17PZnF54SVW
	i8u75rBZLFrWyuzA4rF/7hp2j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGPM6J52jrXgr1jF8qnFDYwbhbsYOTkkBEwklpy+xQZhi0lcuLceyObiEBJY
	xCjR//E6E4Tzi1Hi4rlvYFVsAmoSX74cZgexRQRMJTa+n8IIYjMLJEp8u38crEZIwFZi+ovN
	QM0cHJwCdhJ9n2pBwsICDhLXexaygtgsAqoSn2//ZQaxeYHKLxx7xwhhC0r8mHyPBWKklsT6
	nceZIGx5ic1r3jKDjJQQUJd49FcX4gIjiTU3p0OViEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoW
	MLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO82dSOxhXNlgcYhTgYFTi4X2wfU6QEGti
	WXFl7iFGCQ5mJRHeTp65QUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0xBeSXxhsYmZkaW
	RmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA6Lu2YqrzazWrXZbuvaveJFkV
	cW0tzL5kHGR3M/e2n9X2/bmPT5yteqXT9fXQxdpfWyZYrJ19J0vAbFV97Not72e3lAhl6DJt
	FO1O+10yV5tn67QbCxImNmVX3xT9vyLLxuDP1FKpLNOorjM//gRc1GX8WheRsfzBNR0ZySUa
	iUd/+C6tV3G1V2Ipzkg01GIuKk4EABLwGOw3AwAA
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
 drivers/usb/chipidea/ci_hdrc_pci.c |    2 +-
 drivers/usb/dwc3/dwc3-pci.c        |    2 +-
 drivers/usb/gadget/amd5536udc.c    |    2 +-
 drivers/usb/gadget/pch_udc.c       |    2 +-
 drivers/usb/host/uhci-pci.c        |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_pci.c b/drivers/usb/chipidea/ci_hdrc_pci.c
index d514332..241ae34 100644
--- a/drivers/usb/chipidea/ci_hdrc_pci.c
+++ b/drivers/usb/chipidea/ci_hdrc_pci.c
@@ -112,7 +112,7 @@ static void ci_hdrc_pci_remove(struct pci_dev *pdev)
  *
  * Check "pci.h" for details
  */
-static DEFINE_PCI_DEVICE_TABLE(ci_hdrc_pci_id_table) = {
+static const struct pci_device_id ci_hdrc_pci_id_table[] = {
 	{
 		PCI_DEVICE(0x153F, 0x1004),
 		.driver_data = (kernel_ulong_t)&pci_platdata,
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 31443ae..665686e 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -182,7 +182,7 @@ static void dwc3_pci_remove(struct pci_dev *pci)
 	pci_disable_device(pci);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(dwc3_pci_id_table) = {
+static const struct pci_device_id dwc3_pci_id_table[] = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_SYNOPSYS,
 				PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3),
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 54a1e29..f0ff4a6 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3338,7 +3338,7 @@ static int udc_remote_wakeup(struct udc *dev)
 }
 
 /* PCI device parameters */
-static DEFINE_PCI_DEVICE_TABLE(pci_id) = {
+static const struct pci_device_id pci_id[] = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x2096),
 		.class =	(PCI_CLASS_SERIAL_USB << 8) | 0xfe,
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 32d5e92..78a3d92 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -3210,7 +3210,7 @@ finished:
 	return retval;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pch_udc_pcidev_id) = {
+static const struct pci_device_id pch_udc_pcidev_id[] = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_EG20T_UDC),
 		.class = (PCI_CLASS_SERIAL_USB << 8) | 0xfe,
diff --git a/drivers/usb/host/uhci-pci.c b/drivers/usb/host/uhci-pci.c
index 4cd7988..940304c 100644
--- a/drivers/usb/host/uhci-pci.c
+++ b/drivers/usb/host/uhci-pci.c
@@ -279,7 +279,7 @@ static const struct hc_driver uhci_driver = {
 	.hub_control =		uhci_hub_control,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(uhci_pci_ids) = { {
+static const struct pci_device_id uhci_pci_ids[] = { {
 	/* handle any USB UHCI controller */
 	PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_USB_UHCI, ~0),
 	.driver_data =	(unsigned long) &uhci_driver,
-- 
1.7.10.4


