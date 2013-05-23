Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab3EWUxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:53:46 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:63208 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758979Ab3EWUxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:53:45 -0400
Date: Thu, 23 May 2013 13:53:43 -0700
From: Lisa Nguyen <lisa@xenapiadmin.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] staging/silicom/bypasslib: Add space around ||
Message-ID: <b1b344ad94289e22a135dfd64c23d30665178b13.1369342182.git.lisa@xenapiadmin.com>
References: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added space around piping symbols to resolve checkpatch errors and
meet kernel coding standards in bplibk.h

Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
---
 drivers/staging/silicom/bypasslib/bplibk.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/silicom/bypasslib/bplibk.h b/drivers/staging/silicom/bypasslib/bplibk.h
index cf8eecd..b15a2a4 100644
--- a/drivers/staging/silicom/bypasslib/bplibk.h
+++ b/drivers/staging/silicom/bypasslib/bplibk.h
@@ -25,7 +25,7 @@
 
 #define PEGII_IF_SERIES(vid, pid) \
 	((vid == 0x8086) && \
-	 ((pid == INTEL_PEG4BPII_PID)||   \
+	 ((pid == INTEL_PEG4BPII_PID) ||   \
 	  (pid == INTEL_PEG4BPFII_PID)))
 
 #define EXPORT_SYMBOL_NOVERS EXPORT_SYMBOL
-- 
1.8.1.2

