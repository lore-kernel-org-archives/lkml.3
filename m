Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514AbaCQNgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:36:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbaCQNbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:37 -0400
Message-Id: <20140317133136.922474744@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:28:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 36/39] iscsi_tcp: use blk_mq
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0036-iscsi_tcp-use-blk_mq.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/iscsi_tcp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index add6d15..44aae3d 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -957,6 +957,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
+	.use_blk_mq		= true,
 };
 
 static struct iscsi_transport iscsi_sw_tcp_transport = {
-- 
1.7.10.4


