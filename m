Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3AKQHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 11:07:07 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:37986 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab3AKQHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:07:06 -0500
Date: Fri, 11 Jan 2013 17:07:03 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Build regressions/improvements in v3.8-rc3
In-Reply-To: <alpine.DEB.2.00.1301111704550.22961@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1301111705170.23005@ayla.of.borg>
References: <alpine.DEB.2.00.1301111704550.22961@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.8-rc3 to v3.8-rc2[3], the summaries are:
>   - build errors: +2/-414

  + arch/powerpc/sysdev/mpic.c: error: case label does not reduce to an integer constant:  => 890:9, 898:9, 886:9, 894:9
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A 

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5780/ (all 117 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5767/ (all 117 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
