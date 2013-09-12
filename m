Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3ILTL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:11:26 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47470 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3ILTLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <1379012038-31764-1-git-send-email-msalter@redhat.com>
References: <1379012038-31764-1-git-send-email-msalter@redhat.com>
Date: Thu, 12 Sep 2013 21:11:23 +0200
X-Google-Sender-Auth: cbfMjgZF5KZz_13Elipp2o7qGrg
Message-ID: <CAMuHMdUDsYwJeJQi=yZBY7CfXxhd7RsFUUcZKns8z-5JqX=00g@mail.gmail.com>
Subject: Re: [PATCH] Kconfig cleanup (PARPORT_PC dependencies)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Salter <msalter@redhat.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 8:53 PM, Mark Salter <msalter@redhat.com> wrote:
> Remove messy dependencies from PARPORT_PC by having it depend on one
> Kconfig symbol (ARCH_MAY_HAVE_PC_PARPORT) and having architectures
> which need it declare ARCH_MAY_HAVE_PC_PARPORT in arch/*/Kconfig.
> New architectures are unlikely to need PARPORT_PC, so this avoids
> having an ever growing list of architectures to exclude. Those
> architectures which do declare ARCH_MAY_HAVE_PC_PARPORT in this
> patch are the ones which have an asm/parport.h.
>
> Signed-off-by: Mark Salter <msalter@redhat.com>

Thanks!

For the m68k part:
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
