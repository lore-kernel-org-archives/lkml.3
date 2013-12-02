Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3LBXAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:00:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32071 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3LBXAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:00:34 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-d6-529d110cdaac
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'John W. Linville'" <linville@tuxdriver.com>,
        "=?iso-8859-2?Q?'Rafa=B3_Mi=B3ecki'?=" <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 02/39] bcma: pci: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:00:27 +0900
Message-id: <001701ceefb2$4ad65260$e082f720$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAALlRw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY10ewblBBq9fsVs0L17PZnF54SVW
	i8u75rBZvFlxh91ia4+ExZqTqQ5sHjtn3WX32D93DbtH35ZVjB5Xvq9m9Pi8SS6ANYrLJiU1
	J7MstUjfLoErY8mxdawFU9kqfr7sZ29gnMfaxcjBISFgIvFtu3kXIyeQKSZx4d56ti5GLg4h
	gWWMEo1fmpggEiYS9y6uY4VILGKUmHb7ClTVL0aJfZ0zmUGq2ATUJL58OcwOYosImEpsfD+F
	EaSIWeASo8SUxl0sIAkhAVuJ6S82M4Gs5hSwk+j7VAsSFhZwk+j/dQ9sG4uAqsTGw9MZQWxe
	oPITnf+ZIWxBiR+T77GAtDIL6Eh8nRQBEmYWkJfYvOYtM8Qz6hKP/upCXGAksWDaA2aIEhGJ
	fS/eMUL88pZd4s3SBIhNAhLfJh9igWiVldh0gBmiRFLi4IobLBMYJWYh2TsLYe8sJHtnIVmw
	gJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIpPbuYLx9wPoQYzLQ9onMUqLJ+cBIzyuJ
	NzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRudufv6H
	1zsKjaRaJ81i+N071e3/csuPPPraW987iqzOE3+18OWULWITRPT8lpzXtj9TsfOy47Ozm66L
	v4+dofn/E5+beo1eyNIEDakwvlU8PBMWb+RlatFceW/fl0+nWo+V2W60+f41m8F71epXJR+2
	yU3hVH7R6DC96u+027IJz6qEv208vFyJpTgj0VCLuag4EQDEqlkM6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV0ewblBBqcOM1s0L17PZnF54SVW
	i8u75rBZvFlxh91ia4+ExZqTqQ5sHjtn3WX32D93DbtH35ZVjB5Xvq9m9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aSY+tYC6ayVfx82c/ewDiPtYuRk0NC
	wETi3sV1ULaYxIV769m6GLk4hAQWMUpMu30FyvnFKLGvcyYzSBWbgJrEly+H2UFsEQFTiY3v
	pzCCFDELXGKUmNK4iwUkISRgKzH9xWamLkYODk4BO4m+T7UgYWEBN4n+X/eYQGwWAVWJjYen
	M4LYvEDlJzr/M0PYghI/Jt9jAWllFtCR+DopAiTMLCAvsXnNW2aQsISAusSjv7oQFxhJLJj2
	gBmiRERi34t3jBMYhWYhGTQLYdAsJINmIelYwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93
	EyM4FTyT2sG4ssHiEKMAB6MSD++D7XOChFgTy4orcw8xSnAwK4nwdvLMDRLiTUmsrEotyo8v
	Ks1JLT7EmAz05kRmKdHkfGCayiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampB
	ahHMFiYOTqkGRl9+b/0X2eurDqz4EHai753uv+Cts22q7ffsS5w7ZbH//awq1dY7xnNfvjug
	xTFf2kXi7d/b2i0Wk92bzv3lmSBdnLKloX93w5f+PKXJVq8kvyQteTA9+Od0FtmVfYvvHjY+
	fXbSMWvH//O+ZUhm2awQ2KO7zN/m6vHbupUzS12n1D+fselNoowSS3FGoqEWc1FxIgA9tZWW
	SQMAAA==
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
 drivers/bcma/host_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 6fb98b5..6fe0909 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -270,7 +270,7 @@ static SIMPLE_DEV_PM_OPS(bcma_pm_ops, bcma_host_pci_suspend,
 
 #endif /* CONFIG_PM_SLEEP */
 
-static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
+static const struct pci_device_id bcma_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4313) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43224) },
-- 
1.7.10.4


