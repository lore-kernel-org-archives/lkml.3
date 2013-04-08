Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934987Ab3DHL1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:27:17 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:64078 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934853Ab3DHL1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:27:16 -0400
Message-ID: <1365420434.1830.94.camel@x61.thuisdomein>
Subject: [PATCH] powerpc: remove unused "config 405EP"
From: Paul Bolle <pebolle@tiscali.nl>
To: Josh Boyer <jwboyer@gmail.com>, Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 13:27:14 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2013 11:27:14.0524 (UTC) FILETIME=[04EEC9C0:01CE344C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users of Kconfig symbol 405EP were removed in release v2.6.27.
Remove this symbol (and a useless select of it) too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested by grepping the tree only.

1) There's also a Kconfig symbol EP405. Let's hope no one ever made a
typo with either of these two symbols!

 arch/powerpc/platforms/40x/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
index 7b7a77c..bd40bbb 100644
--- a/arch/powerpc/platforms/40x/Kconfig
+++ b/arch/powerpc/platforms/40x/Kconfig
@@ -20,7 +20,6 @@ config HOTFOOT
         bool "Hotfoot"
 	depends on 40x
 	default n
-	select 405EP
 	select PPC40x_SIMPLE
 	select PCI
         help
@@ -105,9 +104,6 @@ config 405GP
 	select IBM405_ERR51
 	select IBM_EMAC_ZMII
 
-config 405EP
-	bool
-
 config 405EX
 	bool
 	select IBM_EMAC_EMAC4
-- 
1.7.11.7

