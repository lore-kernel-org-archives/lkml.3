Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3JHHBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:01:45 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:58096 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3JHHBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:01:40 -0400
Date: Tue, 8 Oct 2013 09:00:54 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        linux-alpha@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
        linux-mips@linux-mips.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v2 14/14] Kconfig cleanup (PARPORT_PC dependencies)
Message-ID: <20131008070054.GE1615@linux-mips.org>
References: <1381209030-351-1-git-send-email-msalter@redhat.com>
 <1381209030-351-15-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381209030-351-15-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 01:10:30AM -0400, Mark Salter wrote:

> Remove messy dependencies from PARPORT_PC by having it depend on one
> Kconfig symbol (ARCH_MAY_HAVE_PC_PARPORT) and having architectures
> which need it, select ARCH_MAY_HAVE_PC_PARPORT in arch/*/Kconfig.
> New architectures are unlikely to need PARPORT_PC, so this avoids
> having an ever growing list of architectures to exclude. Those
> architectures which do select ARCH_MAY_HAVE_PC_PARPORT in this
> patch are the ones which have an asm/parport.h (or use the generic
> version).

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
