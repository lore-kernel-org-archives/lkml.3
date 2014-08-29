Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaH2USk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:18:40 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:41014 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaH2USj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:18:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 0/4] More section-related cleanups
Date: Fri, 29 Aug 2014 22:18:32 +0200
Message-Id: <1409343516-5132-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Andrew,

Here's a resend of 4 more patches from the series "[PATCH 00/17]
<asm/sections.h> related cleanups" I sent almost one year ago
(https://lkml.org/lkml/2013/11/12/510).

3 of them received acks from their maintainers.

Thanks for applying!

Geert Uytterhoeven (4):
  frv: Remove unused declarations of __start___ex_table and
    __stop___ex_table
  ia64: Remove duplicate declarations of __per_cpu_start[] and
    __per_cpu_end[]
  tile: Remove tile-specific _sinitdata and _einitdata
  kernel/param: Consolidate __{start,stop}___param[] in
    <linux/moduleparam.h>

 arch/frv/mm/extable.c            |  2 --
 arch/ia64/include/asm/sections.h |  2 +-
 arch/tile/include/asm/sections.h |  3 ---
 arch/tile/kernel/vmlinux.lds.S   |  2 --
 arch/tile/mm/init.c              | 10 +++++-----
 include/linux/moduleparam.h      |  2 ++
 init/main.c                      |  2 --
 kernel/params.c                  |  7 +++----
 8 files changed, 11 insertions(+), 19 deletions(-)

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
