Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaEBIHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:07:02 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:51028 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbaEBIG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:06:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsEAHZRY1Ol5H4J/2dsb2JhbABahkLCN4EmdIImAQV5EAhJVxmIQcl4F41uZAcWhCMEmTCSb4NGK4Es
From: Alistair Popple <alistair@popple.id.au>
To: benh@kernel.crashing.org
Cc: pebolle@tiscali.nl, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>
Subject: [PATCH] IBM Akebono: Remove obsolete config select
Date: Fri,  2 May 2014 18:06:45 +1000
Message-Id: <1399018005-23136-1-git-send-email-alistair@popple.id.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398998002.2925.15.camel@pasglop>
References: <1398998002.2925.15.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original implementation of MMC support for Akebono introduced a
new configuration symbol (MMC_SDHCI_OF_476GTR). This symbol has been
dropped in favour of using the generic platform driver however the
select for this symbol was mistakenly left in the platform
configuration.

This patch removes the obsolete symbol selection.

Signed-off-by: Alistair Popple <alistair@popple.id.au>
---
 arch/powerpc/platforms/44x/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 8beec7d..908bf11 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -220,7 +220,6 @@ config AKEBONO
 	select USB_EHCI_HCD_PLATFORM
 	select MMC_SDHCI
 	select MMC_SDHCI_PLTFM
-	select MMC_SDHCI_OF_476GTR
 	select ATA
 	select SATA_AHCI_PLATFORM
 	help
-- 
1.8.3.2

