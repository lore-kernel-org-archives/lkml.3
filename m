Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaFITfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:35:42 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:42460 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaFITfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:35:39 -0400
Date: Mon, 9 Jun 2014 21:35:37 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Build regressions/improvements in v3.15-rc8
In-Reply-To: <alpine.DEB.2.02.1406092134180.21165@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1406092134500.21181@ayla.of.borg>
References: <alpine.DEB.2.02.1406092134180.21165@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.15-rc8[1]  to v3.15-rc7[3], the summaries are:
>   - build errors: +4/-4

  + /scratch/kisskb/src/kernel/bounds.c: error: -mcall-aixdesc must be big endian:  => 1:0
  + /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error: -mcall-aixdesc must be big endian:  => 1:0
  + /scratch/kisskb/src/scripts/mod/empty.c: error: -mcall-aixdesc must be big endian:  => 1:0
  + <stdin>: error: -mcall-aixdesc must be big endian:  => 1:0

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7532/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7506/ (all 119 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
