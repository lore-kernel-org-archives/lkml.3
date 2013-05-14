Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab3ENHcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:32:23 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:35478 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab3ENHcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:32:14 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 5/5] score: Wire up asm-generic/xor.h
Date: Tue, 14 May 2013 09:32:06 +0200
Message-Id: <1368516726-8035-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
References: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
Completely untested due to lack of cross-compiler

 arch/score/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index cebaff8..e1c7bb9 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -3,3 +3,4 @@ header-y +=
 
 generic-y += clkdev.h
 generic-y += trace_clock.h
+generic-y += xor.h
-- 
1.7.0.4

