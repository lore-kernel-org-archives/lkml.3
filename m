Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab3EWUxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:53:15 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53092 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab3EWUxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:53:14 -0400
Date: Thu, 23 May 2013 13:53:12 -0700
From: Lisa Nguyen <lisa@xenapiadmin.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] staging/silicom/bypasslib: Add space around &&
Message-ID: <3f54aaa75abfd279e4c66f865990fb1d1d2e57a8.1369342182.git.lisa@xenapiadmin.com>
References: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added space around double ampersands to resolve checkpatch errors
and meet kernel coding standards in bplibk.h

Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
---
 drivers/staging/silicom/bypasslib/bplibk.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/silicom/bypasslib/bplibk.h b/drivers/staging/silicom/bypasslib/bplibk.h
index bf062c4..cf8eecd 100644
--- a/drivers/staging/silicom/bypasslib/bplibk.h
+++ b/drivers/staging/silicom/bypasslib/bplibk.h
@@ -24,7 +24,7 @@
 #define INTEL_PEG4BPFII_PID 0x10a1
 
 #define PEGII_IF_SERIES(vid, pid) \
-	((vid == 0x8086)&& \
+	((vid == 0x8086) && \
 	 ((pid == INTEL_PEG4BPII_PID)||   \
 	  (pid == INTEL_PEG4BPFII_PID)))
 
-- 
1.8.1.2

