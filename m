Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaLBRID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:08:03 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36665 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaLBRIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:08:00 -0500
Date: Tue, 2 Dec 2014 18:07:56 +0100
From: Michele Curti <michele.curti@gmail.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/dma/pch_dma: declare pch_dma_id_table as static
Message-ID: <20141202170756.GA30256@powerline.azcom-win.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pch_dma_id_table is used in pch_dma.c only, so declare
it as static

Signed-off-by: Michele Curti <michele.curti@gmail.com>
---
 drivers/dma/pch_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 9f9ca9f..6e0e47d 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -997,7 +997,7 @@ static void pch_dma_remove(struct pci_dev *pdev)
 #define PCI_DEVICE_ID_ML7831_DMA1_8CH	0x8810
 #define PCI_DEVICE_ID_ML7831_DMA2_4CH	0x8815
 
-const struct pci_device_id pch_dma_id_table[] = {
+static const struct pci_device_id pch_dma_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_4CH), 4 },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA1_8CH), 8}, /* UART Video */
-- 
2.1.3

