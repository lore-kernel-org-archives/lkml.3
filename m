Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3ENHc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:32:26 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:40020 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab3ENHcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:32:14 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 3/5] h8300: Wire up asm-generic/xor.h
Date: Tue, 14 May 2013 09:32:04 +0200
Message-Id: <1368516726-8035-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
References: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crypto/xor.c:25:21: fatal error: asm/xor.h: No such file or directory

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index e0bce30..8ada3cf 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += linkage.h
 generic-y += mmu.h
 generic-y += module.h
 generic-y += trace_clock.h
+generic-y += xor.h
-- 
1.7.0.4

