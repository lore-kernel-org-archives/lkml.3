Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab3EWUyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:54:09 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33354 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758979Ab3EWUyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:54:07 -0400
Date: Thu, 23 May 2013 13:54:05 -0700
From: Lisa Nguyen <lisa@xenapiadmin.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] staging/silicom/bypasslib: Remove extra space before line
Message-ID: <fb169b1e05d5c30d22bd98357434a2d5aba909f2.1369342182.git.lisa@xenapiadmin.com>
References: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed extra space at beginning of a statement to resolve
checkpatch errors and meet kernel coding standards in bplibk.h

Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
---
 drivers/staging/silicom/bypasslib/bplibk.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/silicom/bypasslib/bplibk.h b/drivers/staging/silicom/bypasslib/bplibk.h
index b15a2a4..f88db4a 100644
--- a/drivers/staging/silicom/bypasslib/bplibk.h
+++ b/drivers/staging/silicom/bypasslib/bplibk.h
@@ -32,7 +32,7 @@
 
 #ifdef BP_VENDOR_SUPPORT
 char *bp_desc_array[] =
-    { "e1000bp", "e1000bpe", "slcm5700", "bnx2xbp", "ixgbp", "ixgbpe", NULL };
+{ "e1000bp", "e1000bpe", "slcm5700", "bnx2xbp", "ixgbp", "ixgbpe", NULL };
 #endif
 
 #endif
-- 
1.8.1.2

