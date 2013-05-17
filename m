Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3EQLSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:18:03 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:54529 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3EQLSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:18:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/4] cris: Wire up asm-generic/vga.h
Date: Fri, 17 May 2013 13:17:45 +0200
Message-Id: <1368789465-3761-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368789465-3761-1-git-send-email-geert@linux-m68k.org>
References: <1368789465-3761-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling several DRM related files:

include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 0dd4b88..c832545 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -9,4 +9,5 @@ generic-y += kvm_para.h
 generic-y += linkage.h
 generic-y += module.h
 generic-y += trace_clock.h
+generic-y += vga.h
 generic-y += xor.h
-- 
1.7.0.4

