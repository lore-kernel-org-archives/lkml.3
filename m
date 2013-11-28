Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab3K1C21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:28:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41641 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab3K1C2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:28:24 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-d6-5296aa470960
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/9] mtd: amd76xrom: use DEFINE_PCI_DEVICE_TABLE macro
Date: Thu, 28 Nov 2013 11:28:22 +0900
Message-id: <001c01ceebe1$825c5060$8714f120$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7r4YIw6u9gU+jASR6kTGnc9PcE+Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zA133VdOCDKas5La4vPASq8X9r0cZ
	LS7vmsNmcbqb1YHF4861PWwe804GevRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfGjRkPWAqO
	cVSs37STqYFxGnsXIyeHhICJxKOTG9ggbDGJC/fWA9lcHEICyxglbq1fxgZTtP/FI0aIxCJG
	ie9/njNBOL8YJX6uesoMUsUmoCbx5cthsLEiQPbNPbOYQGxmgTyJD5s3M4LYwgJuEhtXdrKC
	2CwCqhIndtxgAbF5BWwlNryawAZhC0r8mHyPBaJXS2L9zuNQc+QlNq95C7SLA+gidYlHf3Uh
	VulJNExayAhRIiKx78U7sEMlBNaxS/yf/Qxql4DEt8mHWCB6ZSU2HWCGeExS4uCKGywTGMVm
	Idk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkBjr3cF4+4D1IcZk
	oPUTmaVEk/OBMZpXEm9obGZkYWpiamxkbmlGmrCSOG/Sw6QgIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYybQpkmeu21K897xzqnouWHytWYn2dnul9QUDN1Ll+Z5CjxKKUiTKe4vLTMPOjS
	ilMvtNW0hKb8++bVcvCl8F/1Gce6f0Xx5pfaeq2srw5UrftrtnLTa82tDKuP2J8936Rc3LlL
	dEWpo9Rz9/RfxvNvnw1fJLn90fbZdvO+RLc9ZFrjll79OlGJpTgj0VCLuag4EQA/2HegxwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAV33VdOCDN5tY7e4vPASq8X9r0cZ
	LS7vmsNmcbqb1YHF4861PWwe804GevRtWcXo8XmTXABLVAOjTUZqYkpqkUJqXnJ+SmZeuq2S
	d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QRiWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYR1jxo0ZD1gKjnFUrN+0k6mBcRp7FyMnh4SAicT+F48YIWwxiQv31rN1
	MXJxCAksYpT4/uc5E4Tzi1Hi56qnzCBVbAJqEl++HAbrFgGyb+6ZxQRiMwvkSXzYvBlskrCA
	m8TGlZ2sIDaLgKrEiR03WEBsXgFbiQ2vJrBB2IISPybfY4Ho1ZJYv/M41Bx5ic1r3gLt4gC6
	SF3i0V9diFV6Eg2TFjJClIhI7HvxjnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs81
	0itOzC0uzUvXS87P3cQIjuBn0jsYVzVYHGIU4GBU4uGV0JkWJMSaWFZcmXuIUYKDWUmEV6EY
	KMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wOSSVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbr
	QCGB9MSS1OzU1ILUIpgtTBycUg2MnbW5CpPk1y5e3WGl/nlWwyODo3F1nmWOmocCjO5Mtb8T
	UpNjzXsmI5JtxfHdE/N7Fc40eV7NvMPwJ96ruFq0VmvXwWlSWwxn+DCFXS4qfZQjNjuY4Zv1
	gtfLvkbNvr7dYcOuV+bRV6YefjRBbknH+R3rD/Zd6L4165z81k0sxz3EGU/UC6xZosRSnJFo
	qMVcVJwIABizZWwkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is used to create a struct pci_device_id array.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mtd/maps/amd76xrom.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/maps/amd76xrom.c b/drivers/mtd/maps/amd76xrom.c
index f7207b0..6a0582e 100644
--- a/drivers/mtd/maps/amd76xrom.c
+++ b/drivers/mtd/maps/amd76xrom.c
@@ -296,7 +296,7 @@ static void amd76xrom_remove_one(struct pci_dev *pdev)
 	amd76xrom_cleanup(window);
 }
 
-static struct pci_device_id amd76xrom_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(amd76xrom_pci_tbl) = {
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_VIPER_7410,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_VIPER_7440,
@@ -319,7 +319,7 @@ static struct pci_driver amd76xrom_driver = {
 static int __init init_amd76xrom(void)
 {
 	struct pci_dev *pdev;
-	struct pci_device_id *id;
+	const struct pci_device_id *id;
 	pdev = NULL;
 	for(id = amd76xrom_pci_tbl; id->vendor; id++) {
 		pdev = pci_get_device(id->vendor, id->device, NULL);
-- 
1.7.10.4


