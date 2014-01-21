Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaAUUiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:38:07 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:42496 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaAUUiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:38:01 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] Score: Remove "select HAVE_GENERIC_HARDIRQS" again
Date: Tue, 21 Jan 2014 21:37:52 +0100
Message-Id: <1390336672-21921-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5fbbf8a1a93452b26e7791cf32cefce62b0a480b ("Score: The commit is for
compiling successfully.") re-introduced "select HAVE_GENERIC_HARDIRQS" in
v3.12-rc4, which had just been removed in v3.12-rc1 by commit
0244ad004a54e39308d495fee0a2e637f8b5c317 ("Remove GENERIC_HARDIRQ config
option").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/score/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 305f7ee1f382..c75d06aa27c3 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -2,7 +2,6 @@ menu "Machine selection"
 
 config SCORE
        def_bool y
-       select HAVE_GENERIC_HARDIRQS
        select GENERIC_IRQ_SHOW
        select GENERIC_IOMAP
        select GENERIC_ATOMIC64
-- 
1.7.9.5

