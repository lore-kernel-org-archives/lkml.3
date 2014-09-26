Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaIZRpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:45:38 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:63903 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755231AbaIZRpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:45:36 -0400
Message-ID: <1411753534.7866.66.camel@x220>
Subject: [PATCH] [TRIVIAL] powerpc: Fix comment typos 'CONFiG_ALTIVEC'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 19:45:34 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2014 17:45:35.0791 (UTC) FILETIME=[AD5B3BF0:01CFD9B1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested!

 arch/powerpc/lib/copyuser_power7.S | 2 +-
 arch/powerpc/lib/memcpy_power7.S   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/lib/copyuser_power7.S b/arch/powerpc/lib/copyuser_power7.S
index c46c876ac96a..92ee840529bc 100644
--- a/arch/powerpc/lib/copyuser_power7.S
+++ b/arch/powerpc/lib/copyuser_power7.S
@@ -718,4 +718,4 @@ err3;	stb	r0,0(r3)
 
 15:	addi	r1,r1,STACKFRAMESIZE
 	b	exit_vmx_usercopy	/* tail call optimise */
-#endif /* CONFiG_ALTIVEC */
+#endif /* CONFIG_ALTIVEC */
diff --git a/arch/powerpc/lib/memcpy_power7.S b/arch/powerpc/lib/memcpy_power7.S
index 2ff5c142f87b..0830587df16e 100644
--- a/arch/powerpc/lib/memcpy_power7.S
+++ b/arch/powerpc/lib/memcpy_power7.S
@@ -653,4 +653,4 @@ _GLOBAL(memcpy_power7)
 15:	addi	r1,r1,STACKFRAMESIZE
 	ld	r3,-STACKFRAMESIZE+STK_REG(R31)(r1)
 	b	exit_vmx_copy		/* tail call optimise */
-#endif /* CONFiG_ALTIVEC */
+#endif /* CONFIG_ALTIVEC */
-- 
1.9.3

