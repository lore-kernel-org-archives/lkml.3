Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaGNPS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:18:57 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48393 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbaGNPJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:19 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon <linux-hexagon@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 03/38] hexagon: drop ucontext from list exported headers
Date: Mon, 14 Jul 2014 17:08:31 +0200
Message-Id: <1405350546-28467-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ucontext.h is already specified in include/uapi/asm-generic/Kbuild
so this is redundant.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon <linux-hexagon@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/hexagon/include/asm/Kbuild | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 0e69796..1ddcd97 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -1,6 +1,3 @@
-
-header-y += ucontext.h
-
 generic-y += auxvec.h
 generic-y += barrier.h
 generic-y += bug.h
-- 
1.9.3

