Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab3EWUyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:54:50 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41721 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758979Ab3EWUyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:54:49 -0400
Date: Thu, 23 May 2013 13:54:47 -0700
From: Lisa Nguyen <lisa@xenapiadmin.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] staging/silicom/bypasslib: Move opening brace to
 previous line
Message-ID: <98c2d61a81490325c5e990e5836a457a68a98862.1369342182.git.lisa@xenapiadmin.com>
References: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved opening brace to previous line to resolve checkpatch errors and
meet kernel coding standards in bplibk.h

Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
---
 drivers/staging/silicom/bypasslib/bplibk.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/silicom/bypasslib/bplibk.h b/drivers/staging/silicom/bypasslib/bplibk.h
index f88db4a..b31694f 100644
--- a/drivers/staging/silicom/bypasslib/bplibk.h
+++ b/drivers/staging/silicom/bypasslib/bplibk.h
@@ -31,8 +31,8 @@
 #define EXPORT_SYMBOL_NOVERS EXPORT_SYMBOL
 
 #ifdef BP_VENDOR_SUPPORT
-char *bp_desc_array[] =
-{ "e1000bp", "e1000bpe", "slcm5700", "bnx2xbp", "ixgbp", "ixgbpe", NULL };
+char *bp_desc_array[] = { "e1000bp", "e1000bpe", "slcm5700",
+			"bnx2xbp", "ixgbp", "ixgbpe", NULL };
 #endif
 
 #endif
-- 
1.8.1.2

