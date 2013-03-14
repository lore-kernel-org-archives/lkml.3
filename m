Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab3CNPPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:15:00 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:56726 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932325Ab3CNPO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:14:59 -0400
Message-ID: <1363274097.1335.83.camel@x61.thuisdomein>
Subject: [PATCH] powerpc: remove "config 8260_PCI9"
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 16:14:57 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2013 15:14:57.0964 (UTC) FILETIME=[B0A686C0:01CE20C6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last user of Kconfig symbol 8260_PCI9 got removed in release v3.2.
Remove this symbol too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) This probably is a second order effect of my commit
6805ab6daa2b589fe3242d05ddc47a9dbb0c4eb1 ("powerpc: drop unused Kconfig
symbols"). Not sure how I missed that.

 arch/powerpc/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b89d7eb..8014a44 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -774,11 +774,6 @@ config PCI_8260
 	select PPC_INDIRECT_PCI
 	default y
 
-config 8260_PCI9
-	bool "Enable workaround for MPC826x erratum PCI 9"
-	depends on PCI_8260 && !8272
-	default y
-
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
-- 
1.7.11.7

