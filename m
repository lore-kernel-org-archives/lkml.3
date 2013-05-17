Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3EQLSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:18:15 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:54595 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab3EQLSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:18:02 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-parport@lists.infradead.org
Subject: [PATCH 3/4] parport: disable PC-style parallel port support on cris
Date: Fri, 17 May 2013 13:17:44 +0200
Message-Id: <1368789465-3761-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368789465-3761-1-git-send-email-geert@linux-m68k.org>
References: <1368789465-3761-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-parport@lists.infradead.org
---
 drivers/parport/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 24e12d4..78e2098 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -36,7 +36,9 @@ if PARPORT
 config PARPORT_PC
 	tristate "PC-style hardware"
 	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && !S390 && \
-		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN && !XTENSA
+		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN && \
+		!XTENSA && !CRIS
+
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style
-- 
1.7.0.4

