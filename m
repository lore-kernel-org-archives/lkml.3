Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbaCQNdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:33:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298AbaCQNbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:37 -0400
Message-Id: <20140317133137.113837193@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:28:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 37/39] ata_piix: use blk_mq
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0037-ata_piix-use-blk_mq.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/ata_piix.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 6334c8d..df00cef 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1068,6 +1068,7 @@ static u8 piix_vmw_bmdma_status(struct ata_port *ap)
 
 static struct scsi_host_template piix_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
+	.use_blk_mq		= true,
 };
 
 static struct ata_port_operations piix_sata_ops = {
-- 
1.7.10.4


