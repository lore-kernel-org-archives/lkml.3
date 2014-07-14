Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbaGNPSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:18:47 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48402 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbaGNPJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:19 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Chen Liqin <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, David Howells <dhowells@redhat.com>
Subject: [PATCH 04/38] score: drop irrelevant assignment from Kbuild file
Date: Mon, 14 Jul 2014 17:08:32 +0200
Message-Id: <1405350546-28467-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

header-y assignemnt in this file has no effect - drop it.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/score/include/asm/Kbuild | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index 2f947ab..f67b3f6 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -1,7 +1,4 @@
 
-header-y +=
-
-
 generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += cputime.h
-- 
1.9.3

