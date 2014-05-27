Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaE0Iig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:38:36 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:58829 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaE0Iid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:38:33 -0400
Date: Tue, 27 May 2014 10:38:31 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
        linux-sh@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.15-rc7
In-Reply-To: <alpine.DEB.2.02.1405271035140.13584@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1405271035420.13614@ayla.of.borg>
References: <alpine.DEB.2.02.1405271035140.13584@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.15-rc7[1]  to v3.15-rc6[3], the summaries are:
>   - build errors: +4/-1

  + /scratch/kisskb/src/drivers/tty/serial/nwpserial.c: error: implicit declaration of function 'udelay' [-Werror=implicit-function-declaration]:  => 53:3

powerpc-randconfig

  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A

i386-randconfig

  + error: ion.c: undefined reference to `vm_insert_pfn':  => .text+0x66f4c4)
  + error: ion.c: undefined reference to `zap_page_range':  => .text+0x672794)

sh-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7506/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7497/ (all 119 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
