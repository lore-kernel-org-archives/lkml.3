Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3KLT4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:56:53 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:44616 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab3KLT4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:56:44 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>, Jonas Bonn <jonas@southpole.se>
Cc: linux@openrisc.net, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] openrisc: Remove unused declaration of __initramfs_start
Date: Tue, 12 Nov 2013 20:56:21 +0100
Message-Id: <1384286181-16137-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384286181-16137-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
 <1384286181-16137-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/openrisc/kernel/vmlinux.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/openrisc/kernel/vmlinux.h b/arch/openrisc/kernel/vmlinux.h
index 6c0b24772f85..bbcdf21b0b35 100644
--- a/arch/openrisc/kernel/vmlinux.h
+++ b/arch/openrisc/kernel/vmlinux.h
@@ -3,7 +3,6 @@
 
 #ifdef CONFIG_BLK_DEV_INITRD
 extern char __initrd_start, __initrd_end;
-extern char __initramfs_start;
 #endif
 
 #endif
-- 
1.7.9.5

