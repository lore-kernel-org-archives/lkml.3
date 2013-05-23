Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab3EWUwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:52:44 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62513 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758979Ab3EWUwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:52:43 -0400
Date: Thu, 23 May 2013 13:52:41 -0700
From: Lisa Nguyen <lisa@xenapiadmin.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] staging/silicom/bypasslib: Add space around ==
Message-ID: <e6029384c9374c5d94091a07e4c8008325318437.1369342182.git.lisa@xenapiadmin.com>
References: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added space around equal signs to resolve checkpatch errors and
meet kernel coding standards in bplibk.h

Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
---
 drivers/staging/silicom/bypasslib/bplibk.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/silicom/bypasslib/bplibk.h b/drivers/staging/silicom/bypasslib/bplibk.h
index 26ac570..bf062c4 100644
--- a/drivers/staging/silicom/bypasslib/bplibk.h
+++ b/drivers/staging/silicom/bypasslib/bplibk.h
@@ -24,9 +24,9 @@
 #define INTEL_PEG4BPFII_PID 0x10a1
 
 #define PEGII_IF_SERIES(vid, pid) \
-	((vid==0x8086)&& \
-	 ((pid==INTEL_PEG4BPII_PID)||   \
-	  (pid==INTEL_PEG4BPFII_PID)))
+	((vid == 0x8086)&& \
+	 ((pid == INTEL_PEG4BPII_PID)||   \
+	  (pid == INTEL_PEG4BPFII_PID)))
 
 #define EXPORT_SYMBOL_NOVERS EXPORT_SYMBOL
 
-- 
1.8.1.2

