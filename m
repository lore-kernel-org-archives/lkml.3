Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab3D3Tzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 15:55:40 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42904 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759985Ab3D3Tzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 15:55:38 -0400
Date: Tue, 30 Apr 2013 14:55:24 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: [PATCH 4/9] rsxx: Corrected discard support version number.
Message-ID: <20130430195524.GA14601@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13043019-7182-0000-0000-000006797663
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Changing the Discard support version number to the correct
value.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-04-29 13:57:13.417223450 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-04-29 14:00:17.282184704 -0500
@@ -269,7 +269,7 @@ enum rsxx_hw_fifo_flush {
 };
 
 enum rsxx_pci_revision {
-	RSXX_DISCARD_SUPPORT = 2,
+	RSXX_DISCARD_SUPPORT = 4,
 	RSXX_EEH_SUPPORT     = 3,
 };
 

