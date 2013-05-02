Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab3EBA14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:27:56 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40278 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab3EBA1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:27:43 -0400
Date: Wed, 1 May 2013 19:27:37 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: [PATCH 4/8] rsxx: Corrected discard support version number.
Message-ID: <20130502002737.GB29955@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050200-3620-0000-0000-0000024A025B
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
 

