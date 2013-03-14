Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab3CNNrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:47:52 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:54986 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755858Ab3CNNrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:47:51 -0400
Message-ID: <1363268870.1335.75.camel@x61.thuisdomein>
Subject: [PATCH] powerpc/40x: remove unused "config 405GPR"
From: Paul Bolle <pebolle@tiscali.nl>
To: Josh Boyer <jwboyer@gmail.com>, Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 14:47:50 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2013 13:47:50.0461 (UTC) FILETIME=[84D0DED0:01CE20BA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last user of Kconfig symbol 405GPR got removed in release v3.2.
Remove this symbol too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/powerpc/platforms/40x/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
index a392d12..7b7a77c 100644
--- a/arch/powerpc/platforms/40x/Kconfig
+++ b/arch/powerpc/platforms/40x/Kconfig
@@ -119,9 +119,6 @@ config 405EZ
 	select IBM_EMAC_MAL_CLR_ICINTSTAT
 	select IBM_EMAC_MAL_COMMON_ERR
 
-config 405GPR
-	bool
-
 config XILINX_VIRTEX
 	bool
 	select DEFAULT_UIMAGE
-- 
1.7.11.7



