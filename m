Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3E1VLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:11:50 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46894 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab3E1VLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:11:47 -0400
Date: Tue, 28 May 2013 16:11:42 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] rsxx: Corrected discard support version number.
Message-ID: <20130528211142.GD5065@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052821-5806-0000-0000-0000215F523E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Changing the Discard support version number to the correct
value.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------



diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-05-01 18:36:44.698309293 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-05-01 18:37:56.277183367 -0500
@@ -273,7 +273,7 @@ enum rsxx_hw_fifo_flush {
 };
 
 enum rsxx_pci_revision {
-	RSXX_DISCARD_SUPPORT = 2,
+	RSXX_DISCARD_SUPPORT = 4,
 	RSXX_EEH_SUPPORT     = 3,
 };
 

