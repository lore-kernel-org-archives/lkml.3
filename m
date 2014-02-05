Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaBERHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:07:03 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54934 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbaBERFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:05:41 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org
Cc: patches@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 22/22] arm: update boot/compressed/.gitignore
Date: Wed,  5 Feb 2014 17:04:13 +0000
Message-Id: <1391619853-10601-23-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bswapsdi2.S, fdt_empty_tree.c and fdt_sw.c to ignore list.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 arch/arm/boot/compressed/.gitignore |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/compressed/.gitignore b/arch/arm/boot/compressed/.gitignore
index 47279aa..cc3487e 100644
--- a/arch/arm/boot/compressed/.gitignore
+++ b/arch/arm/boot/compressed/.gitignore
@@ -1,4 +1,5 @@
 ashldi3.S
+bswapsdi2.S
 font.c
 lib1funcs.S
 hyp-stub.S
@@ -13,8 +14,10 @@ vmlinux.lds
 # borrowed libfdt files
 fdt.c
 fdt.h
+fdt_empty_tree.c
 fdt_ro.c
 fdt_rw.c
+fdt_sw.c
 fdt_wip.c
 libfdt.h
 libfdt_internal.h
-- 
1.7.10.4

