Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab3KYJBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:01:34 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:39799 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab3KYIzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Subject: [PATCH 07/24] mn10300/uapi: Use Kbuild logic to provide <asm/types.h>
Date: Mon, 25 Nov 2013 09:55:17 +0100
Message-Id: <1385369734-24893-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uapi <asm-generic/types.h> just includes <asm-generic/int-ll64.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com
---
 arch/mn10300/include/uapi/asm/Kbuild  |    3 ++-
 arch/mn10300/include/uapi/asm/types.h |   11 -----------
 2 files changed, 2 insertions(+), 12 deletions(-)
 delete mode 100644 arch/mn10300/include/uapi/asm/types.h

diff --git a/arch/mn10300/include/uapi/asm/Kbuild b/arch/mn10300/include/uapi/asm/Kbuild
index 040178cdb3eb..bdc329ac60aa 100644
--- a/arch/mn10300/include/uapi/asm/Kbuild
+++ b/arch/mn10300/include/uapi/asm/Kbuild
@@ -1,6 +1,8 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
+generic-y += types.h
+
 header-y += auxvec.h
 header-y += bitsperlong.h
 header-y += byteorder.h
@@ -30,5 +32,4 @@ header-y += statfs.h
 header-y += swab.h
 header-y += termbits.h
 header-y += termios.h
-header-y += types.h
 header-y += unistd.h
diff --git a/arch/mn10300/include/uapi/asm/types.h b/arch/mn10300/include/uapi/asm/types.h
deleted file mode 100644
index 8b3f0501b9bc..000000000000
--- a/arch/mn10300/include/uapi/asm/types.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* MN10300 Basic type definitions
- *
- * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#include <asm-generic/int-ll64.h>
-- 
1.7.9.5

