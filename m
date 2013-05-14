Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab3ENHcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:32:24 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:39930 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab3ENHcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:32:12 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mark Salter <msalter@redhat.com>, linux-c6x-dev@linux-c6x.org
Subject: [PATCH 1/5] c6x: Wire up asm-generic/xor.h
Date: Tue, 14 May 2013 09:32:02 +0200
Message-Id: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: linux-c6x-dev@linux-c6x.org
---
Completely untested due to lack of cross-compiler

 arch/c6x/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index 4258b08..e49f918 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -55,3 +55,4 @@ generic-y += types.h
 generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
+generic-y += xor.h
-- 
1.7.0.4

