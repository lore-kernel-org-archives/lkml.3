Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3HEUnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:43:24 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50989 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3HEUnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:22 -0400
Message-ID: <561d3efeddbd419c8488ceb7fdeead0d8d406e6b.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 20/20] tile PCI RC: remove stale include of linux/numa.h
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/pci.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
index 2c001b2..c99ad44 100644
--- a/arch/tile/include/asm/pci.h
+++ b/arch/tile/include/asm/pci.h
@@ -17,7 +17,6 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>
-#include <linux/numa.h>
 #include <asm-generic/pci_iomap.h>
 
 #ifndef __tilegx__
-- 
1.8.3.1

