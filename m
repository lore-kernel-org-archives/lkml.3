Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3LBXFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:05:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10505 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3LBXFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:05:33 -0500
X-AuditID: cbfee68f-b7f336d00000481b-e6-529d123b1829
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Vinod Koul'" <vinod.koul@intel.com>,
        "'Dan Williams'" <dan.j.williams@intel.com>, dmaengine@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 06/39] dma: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:05:31 +0900
Message-id: <001b01ceefb2$ffd995f0$ff8cc1d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAY4nQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zQ11roblBBqemGFlMn3qB0WL11L+s
	Fs2L17NZXF54idXi8q45bBYv+/azOLB5LN7zkslj/9w17B59W1YxenzeJBfAEsVlk5Kak1mW
	WqRvl8CVceHOBZaCJdwVO/b/Ym5gPM/ZxcjJISFgItF5ZCsThC0mceHeejYQW0hgGaPEgXU6
	MDUrF51h7WLkAopPZ5Q4+/IfVNEvRonH0zxBbDYBNYkvXw6zg9giAqYSG99PYQRpYBbYzCjR
	vmg9C0SDrcT0F5uBtnFwcArYSfR9qgUJCws4SDzumgDWyyKgKvHy4G12kBJeoPK1E31BwrwC
	ghI/Jt8Dm8IsoCWxfudxJghbXmLzmrfMIOUSAuoSj/7qQlxgJDHv+Q82iBIRiX0v3oFdIyHw
	iF3idsd9VohVAhLfJh9igeiVldh0gBniXUmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhF
	UwuSC4qT0ouM9YoTc4tL89L1kvNzNzFCorR/B+PdA9aHGJOB1k9klhJNzgdGeV5JvKGxmZGF
	qYmpsZG5pRlpwkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDQK0d600vR+0Kzz
	v5XvSP3pvs12VfuNB4fbxk+v/kR/PP/qWe20oIOXLi92aHljzvb7pVmIR/nHpshTvGs1FJxZ
	/58TWyxSVS23zur246TH+y42TjLyDLV+Iyh7VTPS0sMocrmIrYjMxsWdhWdd08+1r67+JWES
	uvTV8duKE5iNolftMlXo5FNiKc5INNRiLipOBACuFMkf6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV1roblBBg0T9CymT73AaLF66l9W
	i+bF69ksLi+8xGpxedccNouXfftZHNg8Fu95yeSxf+4ado++LasYPT5vkgtgiWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLhw5wJLwRLuih37fzE3MJ7n7GLk5JAQMJFY
	uegMK4QtJnHh3nq2LkYuDiGB6YwSZ1/+YwNJCAn8YpR4PM0TxGYTUJP48uUwO4gtImAqsfH9
	FEaQBmaBzYwS7YvWs0A02EpMf7GZqYuRg4NTwE6i71MtSFhYwEHicdcEsF4WAVWJlwdvs4OU
	8AKVr53oCxLmFRCU+DH5HtgUZgEtifU7jzNB2PISm9e8ZQYplxBQl3j0VxfiAiOJec9/sEGU
	iEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhO
	As+kdjCubLA4xCjAwajEw/tg+5wgIdbEsuLK3EOMEhzMSiK8nTxzg4R4UxIrq1KL8uOLSnNS
	iw8xJgP9OZFZSjQ5H5ig8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSz
	hYmDU6qBUeLgRKlrjk0TbJLv/8184/p6xqMTP3eINvXKuvtm308KVN3/bfFKNU0/gcm3Ba2n
	/z50uXvxE5+pQe/fJh6WkrSRO5t0ULBp/c9LLEdVjrU87N3l1H7y+dlHTa/1a5ZsKIru115e
	0Xih5EIGR17/ZJUDDFHNxzjm6k9OS1g9rU6kcKPuaZmgOCWW4oxEQy3mouJEALjsvchGAwAA
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
 drivers/dma/dw/pci.c  |    2 +-
 drivers/dma/pch_dma.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
index e89fc24..fc3aea1 100644
--- a/drivers/dma/dw/pci.c
+++ b/drivers/dma/dw/pci.c
@@ -75,7 +75,7 @@ static void dw_pci_remove(struct pci_dev *pdev)
 		dev_warn(&pdev->dev, "can't remove device properly: %d\n", ret);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
+static const struct pci_device_id dw_pci_id_table[] = {
 	/* Medfield */
 	{ PCI_VDEVICE(INTEL, 0x0827), (kernel_ulong_t)&dw_pci_pdata },
 	{ PCI_VDEVICE(INTEL, 0x0830), (kernel_ulong_t)&dw_pci_pdata },
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 61fdc54..9f0cdb1 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -996,7 +996,7 @@ static void pch_dma_remove(struct pci_dev *pdev)
 #define PCI_DEVICE_ID_ML7831_DMA1_8CH	0x8810
 #define PCI_DEVICE_ID_ML7831_DMA2_4CH	0x8815
 
-DEFINE_PCI_DEVICE_TABLE(pch_dma_id_table) = {
+const struct pci_device_id pch_dma_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_4CH), 4 },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA1_8CH), 8}, /* UART Video */
-- 
1.7.10.4


