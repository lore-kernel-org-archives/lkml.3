Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaIZRkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:40:20 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:60196 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222AbaIZRkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:40:18 -0400
Message-ID: <1411753216.7866.65.camel@x220>
Subject: [PATCH] [TRIVIAL] m68k: Fix typo 'COFNIG_MBAR'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 19:40:16 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2014 17:40:17.0950 (UTC) FILETIME=[EFE88BE0:01CFD9B0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested!

Geert, PASR is obviously unused. Is it needed?

 arch/m68k/include/asm/m54xxpci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/m54xxpci.h b/arch/m68k/include/asm/m54xxpci.h
index 6fbf54f72f2e..4687f5aa3741 100644
--- a/arch/m68k/include/asm/m54xxpci.h
+++ b/arch/m68k/include/asm/m54xxpci.h
@@ -72,7 +72,7 @@
 #define	PCIRFWPR	(CONFIG_MBAR + 0x84d4)	/* RX FIFO write pointer */
 
 #define	PACR		(CONFIG_MBAR + 0xc00)	/* PCI arbiter control */
-#define	PASR		(COFNIG_MBAR + 0xc04)	/* PCI arbiter status */
+#define	PASR		(CONFIG_MBAR + 0xc04)	/* PCI arbiter status */
 
 /*
  *	Definitions for the Global status and control register.
-- 
1.9.3

