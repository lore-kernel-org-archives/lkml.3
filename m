Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3KLTmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:42:40 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:46785 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3KLTme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:42:34 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/17] <asm/sections.h> related cleanups
Date: Tue, 12 Nov 2013 20:42:10 +0100
Message-Id: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

This started as a small cleanup in the OpenRISC code, but then I got
pulled into the pool of all section-related symbols, many of which are
different or duplicated.

    [PATCH 01/17] alpha: Use Kbuild logic to include <asm-generic/sections.h>
    [PATCH 02/17] cris: Use Kbuild logic to include <asm-generic/sections.h>
    [PATCH 03/17] m32r: Use Kbuild logic to include <asm-generic/sections.h>
    [PATCH 04/17] mn10300: Use Kbuild logic to include <asm-generic/sections.h>
    [PATCH 05/17] score: Use Kbuild logic to include <asm-generic/sections.h>
    [PATCH 06/17] frv: Remove unused declarations of __start___ex_table
    [PATCH 07/17] ia64: Remove duplicate declarations of  __per_cpu_start[]
    [PATCH 08/17] microblaze: Remove _fdt_start casts
    [PATCH 09/17] microblaze: Remove duplicate declarations of _stext[]
    [PATCH 10/17] tile: Remove tile-specific _sinitdata and _einitdata
    [PATCH 11/17] kernel/param: Consolidate __{start,stop}___param[] in
    [PATCH 12/17] nosave: Consolidate __nosave_{begin,end} in
    [PATCH 13/17] openrisc: Refactor or32_early_setup()
    [PATCH 14/17] dt: Consolidate __dtb_start declarations in
    [PATCH RFC 15/17] microblaze: Convert from _fdt_start to __dtb_start
    [PATCH RFC 16/17] c6x: Convert from _fdt_start to __dtb_start
    [PATCH 17/17] um: Remove unused declarations from <as-layout.h>

Most of this has been compile-tested. Notable exceptions are the changes
to arc, c6x, and score code, due to lack of cross-compilers.

Patches 15 and 16 are RFCs, as these make non-trivial changes, and I
couldn't test them.

Thanks for applying/comments/...!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
