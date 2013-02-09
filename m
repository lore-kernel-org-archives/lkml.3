Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789Ab3BIRbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 12:31:52 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:39478 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab3BIRbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 12:31:51 -0500
Date: Sat, 9 Feb 2013 18:31:50 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.8-rc7
In-Reply-To: <alpine.DEB.2.00.1302091829160.19791@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1302091829370.19803@ayla.of.borg>
References: <alpine.DEB.2.00.1302091829160.19791@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.8-rc7 to v3.8-rc6[3], the summaries are:
>   - build errors: +7/-8
> [1] http://kisskb.ellerman.id.au/kisskb/head/5870/ (all 117 configs)

Ignoring the ppc truncated relocations:

  + error: tpm_ibmvtpm.c: undefined reference to `.__vio_register_driver':  => .init.text+0x5554)
  + error: tpm_ibmvtpm.c: undefined reference to `.plpar_hcall_norets':  => .text+0xd7038), .text+0xd713c), .text+0xd70f8), .text+0xd7334), .text+0xd7278)
  + error: tpm_ibmvtpm.c: undefined reference to `.vio_unregister_driver':  => .exit.text+0x1358)

powerpc-randconfig

> [3] http://kisskb.ellerman.id.au/kisskb/head/5846/ (all 117 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
