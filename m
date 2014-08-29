Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaH2To4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:44:56 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:43612 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaH2Tov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:44:51 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        David Howells <dhowells@redhat.com>,
        Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 0/5] Use Kbuild logic to include <asm-generic/sections.h>
Date: Fri, 29 Aug 2014 21:44:38 +0200
Message-Id: <1409341483-3451-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Andrew,

Here's a resend of 5 patches from the series "[PATCH 00/17] <asm/sections.h>
related cleanups" I sent almost one year ago
(https://lkml.org/lkml/2013/11/12/510).

4 of them received acks from their maintainers.

Thanks for applying!

Geert Uytterhoeven (5):
  alpha: Use Kbuild logic to include <asm-generic/sections.h>
  cris: Use Kbuild logic to include <asm-generic/sections.h>
  m32r: Use Kbuild logic to include <asm-generic/sections.h>
  mn10300: Use Kbuild logic to include <asm-generic/sections.h>
  score: Use Kbuild logic to include <asm-generic/sections.h>

 arch/alpha/include/asm/Kbuild       | 1 +
 arch/alpha/include/asm/sections.h   | 7 -------
 arch/cris/include/asm/Kbuild        | 1 +
 arch/cris/include/asm/sections.h    | 7 -------
 arch/m32r/include/asm/Kbuild        | 1 +
 arch/m32r/include/asm/sections.h    | 7 -------
 arch/mn10300/include/asm/Kbuild     | 1 +
 arch/mn10300/include/asm/sections.h | 1 -
 arch/score/include/asm/Kbuild       | 1 +
 arch/score/include/asm/sections.h   | 6 ------
 10 files changed, 5 insertions(+), 28 deletions(-)
 delete mode 100644 arch/alpha/include/asm/sections.h
 delete mode 100644 arch/cris/include/asm/sections.h
 delete mode 100644 arch/m32r/include/asm/sections.h
 delete mode 100644 arch/mn10300/include/asm/sections.h
 delete mode 100644 arch/score/include/asm/sections.h

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
