Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3H3Ebr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:31:47 -0400
Received: from intranet.asianux.com ([58.214.24.6]:29328 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab3H3Ebp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:31:45 -0400
X-Spam-Score: -100.9
Message-ID: <52201FF0.4000307@asianux.com>
Date: Fri, 30 Aug 2013 12:30:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>, Arnd Bergmann <arnd@arndb.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dave Jones <davej@redhat.com>, David Sharp <dhsharp@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] h8300: include: asm: Kbuild: add default "serial.h"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, an architecture need support serial, so include the default
one, or can not pass compiling:

The related error (allmodconfig for h8300):

  In file included from drivers/staging/speakup/speakup_acntpc.c:33:0:
  drivers/staging/speakup/serialio.h:7:24: fatal error: asm/serial.h: No such file or directory


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index 8ada3cf..df289fb 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -4,5 +4,6 @@ generic-y += exec.h
 generic-y += linkage.h
 generic-y += mmu.h
 generic-y += module.h
+generic-y += serial.h
 generic-y += trace_clock.h
 generic-y += xor.h
-- 
1.7.7.6
