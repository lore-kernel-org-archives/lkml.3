Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3GBROA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:14:00 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:54981 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3GBRN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:13:59 -0400
Date: Tue, 2 Jul 2013 19:13:57 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.10
In-Reply-To: <alpine.DEB.2.02.1307021912180.12710@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1307021912500.12738@ayla.of.borg>
References: <alpine.DEB.2.02.1307021912180.12710@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.10 to v3.10-rc7[3], the summaries are:
>   - build errors: +6/-38

All R_PPC64_REL24 truncations in powerpc-allyesconfig.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
