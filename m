Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3KYI5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:57:15 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:50539 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3KYIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:46 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 03/24] cris/uapi: Use Kbuild logic to provide <asm/types.h>
Date: Mon, 25 Nov 2013 09:55:13 +0100
Message-Id: <1385369734-24893-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uapi <asm-generic/types.h> just includes <asm-generic/int-ll64.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
---
 arch/cris/include/uapi/asm/Kbuild  |    3 ++-
 arch/cris/include/uapi/asm/types.h |    1 -
 2 files changed, 2 insertions(+), 2 deletions(-)
 delete mode 100644 arch/cris/include/uapi/asm/types.h

diff --git a/arch/cris/include/uapi/asm/Kbuild b/arch/cris/include/uapi/asm/Kbuild
index 7d47b366ad82..4d925e6cce72 100644
--- a/arch/cris/include/uapi/asm/Kbuild
+++ b/arch/cris/include/uapi/asm/Kbuild
@@ -1,6 +1,8 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
+generic-y += types.h
+
 header-y += arch-v10/
 header-y += arch-v32/
 header-y += auxvec.h
@@ -35,5 +37,4 @@ header-y += swab.h
 header-y += sync_serial.h
 header-y += termbits.h
 header-y += termios.h
-header-y += types.h
 header-y += unistd.h
diff --git a/arch/cris/include/uapi/asm/types.h b/arch/cris/include/uapi/asm/types.h
deleted file mode 100644
index 9ec9d4c5ac4d..000000000000
--- a/arch/cris/include/uapi/asm/types.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/int-ll64.h>
-- 
1.7.9.5

