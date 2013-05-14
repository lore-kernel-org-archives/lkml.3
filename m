Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab3ENHcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:32:19 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:39929 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab3ENHcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:32:12 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 2/5] cris: Wire up asm-generic/xor.h
Date: Tue, 14 May 2013 09:32:03 +0200
Message-Id: <1368516726-8035-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
References: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crypto/xor.c:25:21: fatal error: asm/xor.h: No such file or directory

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
---
 arch/cris/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 1e7dfad..0dd4b88 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -9,3 +9,4 @@ generic-y += kvm_para.h
 generic-y += linkage.h
 generic-y += module.h
 generic-y += trace_clock.h
+generic-y += xor.h
-- 
1.7.0.4

