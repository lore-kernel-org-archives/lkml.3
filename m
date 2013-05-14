Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab3ENHcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:32:21 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:39974 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab3ENHcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:32:13 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 4/5] openrisc: Wire up asm-generic/xor.h
Date: Tue, 14 May 2013 09:32:05 +0200
Message-Id: <1368516726-8035-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
References: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crypto/xor.c:25:21: error: asm/xor.h: No such file or directory

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index f20d01d..195653e 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -66,3 +66,4 @@ generic-y += types.h
 generic-y += ucontext.h
 generic-y += user.h
 generic-y += word-at-a-time.h
+generic-y += xor.h
-- 
1.7.0.4

