Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3FDWly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:41:54 -0400
Received: from 1wt.eu ([62.212.114.60]:35311 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3FDWlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:49 -0400
Message-Id: <20130604172132.301287063@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Romain Francoise <romain@orebokech.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 048/184] x86, random: make ARCH_RANDOM prompt if EMBEDDED,
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 not EXPERT

From: Romain Francoise <romain@orebokech.com>

Before v2.6.38 CONFIG_EXPERT was known as CONFIG_EMBEDDED but the
Kconfig entry was not changed to match when upstream commit
628c6246d47b85f5357298601df2444d7f4dd3fd ("x86, random: Architectural
inlines to get random integers with RDRAND") was backported.

Signed-off-by: Romain Francoise <romain@orebokech.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index aa889d6..ee0168d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1430,7 +1430,7 @@ config ARCH_USES_PG_UNCACHED
 
 config ARCH_RANDOM
 	def_bool y
-	prompt "x86 architectural random number generator" if EXPERT
+	prompt "x86 architectural random number generator" if EMBEDDED
 	---help---
 	  Enable the x86 architectural RDRAND instruction
 	  (Intel Bull Mountain technology) to generate random numbers.
-- 
1.7.12.2.21.g234cd45.dirty



