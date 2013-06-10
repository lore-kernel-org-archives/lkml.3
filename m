Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab3FJHZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:25:34 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:43175 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3FJHZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:25:33 -0400
Date: Mon, 10 Jun 2013 09:25:31 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Build regressions/improvements in v3.10-rc5
In-Reply-To: <alpine.DEB.2.00.1306100922530.21948@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1306100924570.22024@ayla.of.borg>
References: <alpine.DEB.2.00.1306100922530.21948@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.10-rc5 to v3.10-rc4[3], the summaries are:
>   - build errors: +19/-10
> [1] http://kisskb.ellerman.id.au/kisskb/head/6308/ (all 120 configs)

 + arch/powerpc/kernel/cacheinfo.c: error: 'associativity' may be used uninitialized in this function [-Werror=uninitialized]:  => 571:16
  + arch/powerpc/kernel/cacheinfo.c: error: 'size_kb' may be used uninitialized in this function [-Werror=uninitialized]:  => 522:16
  + arch/powerpc/kernel/pci_dn.c: error: 'ret' may be used uninitialized in this function [-Werror=uninitialized]:  => 97:8
  + arch/powerpc/kvm/book3s_32_mmu.c: error: 'sr' may be used uninitialized in this function [-Werror=uninitialized]:  => 63:2
  + arch/powerpc/kvm/book3s_64_mmu.c: error: 'slb' may be used uninitialized in this function [-Werror=uninitialized]:  => 485:3
  + arch/powerpc/mm/hash_native_64.c: error: 'a_size' may be used uninitialized in this function [-Werror=uninitialized]:  => 67:31
  + arch/powerpc/platforms/cell/spufs/inode.c: error: incompatible types when assigning to type 'kgid_t' from type 'int':  => 628:16
  + arch/powerpc/platforms/cell/spufs/inode.c: error: incompatible types when assigning to type 'kuid_t' from type 'int':  => 623:16
  + arch/powerpc/platforms/pseries/msi.c: error: 'total' may be used uninitialized in this function [-Werror=uninitialized]:  => 320:24
  + arch/powerpc/platforms/pseries/pci.c: error: 'pcie_link_speed_stats' may be used uninitialized in this function [-Werror=uninitialized]:  => 150:31

powerpc-randconfig

> [3] http://kisskb.ellerman.id.au/kisskb/head/6290/ (all 120 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
