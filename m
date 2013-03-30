Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3C3JGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 05:06:10 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:55383 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611Ab3C3JGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 05:06:08 -0400
Message-ID: <1364634366.1345.111.camel@x61.thuisdomein>
Subject: [PATCH] [RESEND] arch: remove CONFIG_GENERIC_FIND_NEXT_BIT again
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Kuo <rkuo@codeaurora.org>, Jonas Bonn <jonas@southpole.se>
Cc: linux-hexagon@vger.kernel.org, linux@openrisc.net,
        linux-kernel@vger.kernel.org
Date: Sat, 30 Mar 2013 10:06:06 +0100
In-Reply-To: <51545BFB.9010806@southpole.se>
References: <1363872898.1390.143.camel@x61.thuisdomein>
	 <ed19f23c22d5a92cda8e3622060bed61.squirrel@www.codeaurora.org>
	 <51545BFB.9010806@southpole.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Mar 2013 09:06:06.0120 (UTC) FILETIME=[CFA72280:01CE2D25]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_GENERIC_FIND_NEXT_BIT was removed in v3.0, but reappeared in two
architectures. Remove it again.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Jonas Bonn <jonas@southpole.se>
---
0) Richard asked (off list) to resend. There appear to be problems
locating the patch in the archives for LKML and/or linux-hexagon.

1) Added Jonas' ACK. Richard will pull the patch in a hexagon tree and
handle it from there.

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

