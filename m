Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965752Ab3CZQGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:06:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:33633 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965685Ab3CZQGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:06:45 -0400
Date: Tue, 26 Mar 2013 11:06:35 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com
Subject: [PATCH 02/02] block: removes unused variable.
Message-ID: <20130326160635.GE7136@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032616-3620-0000-0000-000001C6C6D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Removed unused variable.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------
This patch may have been already submitted but I haven't seen it be applied yet.
So I am going to go ahead and send the fix so that I am sure there has been a patch
sent out.



diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-03-26 10:02:29.942964930 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-03-26 10:02:56.839969991 -0500
@@ -1056,7 +1056,6 @@ void rsxx_eeh_cancel_dmas(struct rsxx_ca
 int rsxx_eeh_remap_dmas(struct rsxx_cardinfo *card)
 {
 	struct rsxx_dma *dma;
-	struct rsxx_dma *tmp;
 	int i;
 
 	for (i = 0; i < card->n_targets; i++) {

