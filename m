Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958Ab3ICL1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 07:27:33 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:50694 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759831Ab3ICL1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:27:32 -0400
Date: Tue, 3 Sep 2013 13:27:21 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.11
In-Reply-To: <alpine.DEB.2.02.1309031323510.27532@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1309031324560.27545@ayla.of.borg>
References: <alpine.DEB.2.02.1309031323510.27532@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.11 to v3.11-rc7[3], the summaries are:
>   - build errors: +9/-17

Besides the usual ppc64 relocation truncations and powerpc-randconfig
breakage, there's only:

  + error: "__ashrdi3" [fs/ntfs/ntfs.ko] undefined!:  => N/A

sh4/landisk_defconfig

  + error: "__ashrdi3" [fs/xfs/xfs.ko] undefined!:  => N/A
  + error: "max_low_pfn" [drivers/block/aoe/aoe.ko] undefined!:  => N/A
  + error: "min_low_pfn" [drivers/block/aoe/aoe.ko] undefined!:  => N/A

sh4/titan_defconfig

But even these are not new; they were hidden by the USB build errors in
v3.11-rc7.

> [1] http://kisskb.ellerman.id.au/kisskb/head/6601/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6579/ (all 120 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
