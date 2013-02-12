Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277Ab3BLO5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:57:46 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:40438 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680Ab3BLOxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 09/10] cris: Provide <asm/kvm_para.h>
Date: Tue, 12 Feb 2013 15:52:56 +0100
Message-Id: <1360680777-12622-10-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
References: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from include/linux/kvm_para.h:4:0,
                 from kernel/watchdog.c:28:
include/uapi/linux/kvm_para.h:26:26: fatal error: asm/kvm_para.h: No such file or directory

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index f1e79ed..7478488 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -5,5 +5,6 @@ header-y += arch-v32/
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += kvm_para.h
 generic-y += module.h
 generic-y += trace_clock.h
-- 
1.7.0.4

