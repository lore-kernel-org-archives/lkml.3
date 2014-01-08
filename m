Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaAHWMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:12:07 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:51265 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbaAHWMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:12:00 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: John Crispin <blogic@openwrt.org>, Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhc@lemote.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 0/2] Linux 3.13: Fix MIPS/loongson2 regression
Date: Thu,  9 Jan 2014 00:11:17 +0200
Message-Id: <1389219079-6133-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

During the 3.13 merge window, MIPS/loongson2 support got badly broken:
none of the boards are booting at all. The following patches fixes it.
Since the MIPS maintainer has been away during the whole -rc cycle,
I'm sending these patches directly to you.

MIPS patchwork links to the patches:
	http://patchwork.linux-mips.org/patch/6176/
	http://patchwork.linux-mips.org/patch/6175/

Please consider including these fixes to 3.13 release, thanks.

A.

Aaro Koskinen (1):
  MIPS: fix blast_icache32 on loongson2

Huacai Chen (1):
  MIPS: Fix case mismatch in local_r4k_flush_icache_range()

 arch/mips/include/asm/cacheops.h |  2 +-
 arch/mips/include/asm/r4kcache.h | 51 ++++++++++++++++++++--------------------
 arch/mips/mm/c-r4k.c             | 11 +++++++--
 3 files changed, 36 insertions(+), 28 deletions(-)

-- 
1.8.5.2

