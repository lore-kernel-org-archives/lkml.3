Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3GVAQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:16:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37316 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753502Ab3GVAQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:16:44 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/18] MAINTAINERS: ARM: plat-nomadik: Update patterns
Date: Sun, 21 Jul 2013 17:15:33 -0700
Message-Id: <fc5e7c01499407d31060a705f51d82ab2655e6a6.1374451988.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 694e33a7f4 ("ARM: plat-nomadik: move MTU, kill plat-nomadik")
moved the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Linus Walleij <linus.walleij@linaro.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e90164..ab9a5c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1023,7 +1023,6 @@ M:	STEricsson <STEricsson_nomadik_linux@list.st.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-nomadik/
-F:	arch/arm/plat-nomadik/
 F:	drivers/i2c/busses/i2c-nomadik.c
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-nomadik.git
 
-- 
1.8.1.2.459.gbcd45b4.dirty

