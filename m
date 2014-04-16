Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbaDPUpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:45:43 -0400
Received: from mxip4-inbound.gatech.edu ([130.207.182.13]:21226 "EHLO
	mxip4-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaDPUpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:45:42 -0400
X-RemoteIP: 130.207.185.166
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 79245098
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.97,874,1389762000"; 
   d="scan'208";a="79245098"
X-GT-Spam-Rating: (0%)
Message-ID: <534EEC09.7010300@gatech.edu>
Date: Wed, 16 Apr 2014 16:46:01 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] include/linux/torture.h: remove unused duplicate definition
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove an unused duplicate definition of torture_param

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/torture.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index b2e2b46..88a84a2 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -49,12 +49,6 @@
 #define VERBOSE_TOROUT_ERRSTRING(s) \
 	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! %s\n", torture_type, s); } while (0)
 
-/* Definitions for a non-string torture-test module parameter. */
-#define torture_parm(type, name, init, msg) \
-	static type name = init; \
-	module_param(name, type, 0444); \
-	MODULE_PARM_DESC(name, msg);
-
 /* Definitions for online/offline exerciser. */
 int torture_onoff_init(long ooholdoff, long oointerval);
 char *torture_onoff_stats(char *page);
-- 
1.7.9.5
