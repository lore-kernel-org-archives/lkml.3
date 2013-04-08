Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935783Ab3DHTfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:35:15 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:62235 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935741Ab3DHTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:35:13 -0400
Message-ID: <1365449711.1830.130.camel@x61.thuisdomein>
Subject: [PATCH] powerpc: remove "config MPC10X_OPENPIC"
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 21:35:11 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2013 19:35:11.0642 (UTC) FILETIME=[2F7477A0:01CE3490]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last users of Kconfig symbol MPC10X_OPENPIC were removed in v2.6.27.
Its Kconfig entry can be removed now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/powerpc/platforms/embedded6xx/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/platforms/embedded6xx/Kconfig b/arch/powerpc/platforms/embedded6xx/Kconfig
index 5a8f50a9..302ba43 100644
--- a/arch/powerpc/platforms/embedded6xx/Kconfig
+++ b/arch/powerpc/platforms/embedded6xx/Kconfig
@@ -9,7 +9,6 @@ config LINKSTATION
 	select FSL_SOC
 	select PPC_UDBG_16550 if SERIAL_8250
 	select DEFAULT_UIMAGE
-	select MPC10X_OPENPIC
 	select MPC10X_BRIDGE
 	help
 	  Select LINKSTATION if configuring for one of PPC- (MPC8241)
@@ -24,7 +23,6 @@ config STORCENTER
 	select MPIC
 	select FSL_SOC
 	select PPC_UDBG_16550 if SERIAL_8250
-	select MPC10X_OPENPIC
 	select MPC10X_BRIDGE
 	help
 	  Select STORCENTER if configuring for the iomega StorCenter
@@ -84,9 +82,6 @@ config MV64X60
 	select PPC_INDIRECT_PCI
 	select CHECK_CACHE_COHERENCY
 
-config MPC10X_OPENPIC
-	bool
-
 config GAMECUBE_COMMON
 	bool
 
-- 
1.7.11.7

