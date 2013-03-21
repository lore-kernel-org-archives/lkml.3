Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3CUKNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:13:21 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:50717 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753647Ab3CUKNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:13:20 -0400
Message-ID: <1363860797.1390.108.camel@x61.thuisdomein>
Subject: [PATCH] Hexagon: remove two Kconfig entries
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 11:13:17 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 10:13:18.0159 (UTC) FILETIME=[B537B5F0:01CE261C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entries for HEXAGON_VM and HEXAGON_ANGEL_TRAPS were added,
together with the configuration and makefiles for the Hexagon
architecture, in v3.2. They have never been used. They can safely be
removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/hexagon/Kconfig | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index e4decc6..48130eb 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -109,9 +109,6 @@ config HEXAGON_COMET
 
 endchoice
 
-config HEXAGON_VM
-	def_bool y
-
 config CMDLINE
 	string "Default kernel command string"
 	default ""
@@ -122,12 +119,6 @@ config CMDLINE
 	  minimum, you should specify the memory size and the root device
 	  (e.g., mem=64M root=/dev/nfs).
 
-config HEXAGON_ANGEL_TRAPS
-	bool "Use Angel Traps"
-	default n
-	---help---
-	  Enable angel debug traps (for printk's).
-
 config SMP
 	bool "Multi-Processing support"
 	---help---
-- 
1.7.11.7

