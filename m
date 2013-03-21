Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab3CUNfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:35:05 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:50753 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932450Ab3CUNfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:35:01 -0400
Message-ID: <1363872898.1390.143.camel@x61.thuisdomein>
Subject: [PATCH] arch: remove CONFIG_GENERIC_FIND_NEXT_BIT again
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Kuo <rkuo@codeaurora.org>, Jonas Bonn <jonas@southpole.se>
Cc: linux-hexagon@vger.kernel.org, linux@openrisc.net,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 14:34:58 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 13:34:58.0440 (UTC) FILETIME=[E18C1080:01CE2638]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_GENERIC_FIND_NEXT_BIT was removed in v3.0, but reappeared in two
architectures. Remove it again.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) See commit 63e424c84429903c92a0f1e9654c31ccaf6694d0 ("arch: remove
CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}") for the removal of this
Kconfig symbol.

2) Sent as one patch. Feel free to tell me to split it up in two
patches.

 arch/hexagon/Kconfig  | 3 ---
 arch/openrisc/Kconfig | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 48130eb..650ef81 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -81,9 +81,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool y
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 9ab3bf2..81b9ddb 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -55,9 +55,6 @@ config TRACE_IRQFLAGS_SUPPORT
 config GENERIC_CSUM
         def_bool y
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
 source "init/Kconfig"
 

-- 
1.7.11.7

