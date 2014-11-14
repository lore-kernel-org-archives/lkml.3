Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161319AbaKNRFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:05:45 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55376 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933486AbaKNRFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:05:43 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+cwHq3FCkD8ZMocp3MZeFeOBsnVzddrw=
X-DKIM: OpenDKIM Filter v2.0.1 titan 936CD61B22F
Date: Fri, 14 Nov 2014 12:05:25 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Florian Fainelli <f.fainelli@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>, Jonas Gorski <jogo@openwrt.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: [PATCH V4 01/14] sh: Eliminate unused irq_reg_{readl,writel}
 accessors
Message-ID: <20141114170525.GL3698@titan.lakedaemon.net>
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
 <1415342669-30640-2-git-send-email-cernekee@gmail.com>
 <CAMuHMdW+L8YbE8Z8jrtnm8xWk63sRGaFdM7TPM6MmrDg9XwHuQ@mail.gmail.com>
 <20141114163843.GH29662@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114163843.GH29662@linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 05:38:44PM +0100, Ralf Baechle wrote:
> On Mon, Nov 10, 2014 at 09:13:49AM +0100, Geert Uytterhoeven wrote:
> 
> > On Fri, Nov 7, 2014 at 7:44 AM, Kevin Cernekee <cernekee@gmail.com> wrote:
> > > Defining these macros way down in arch/sh/.../irq.c doesn't cause
> > > kernel/irq/generic-chip.c to use them.  As far as I can tell this code
> > > has no effect.
> > >
> > > Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> > 
> > Compared preprocessor and asm output before and after, no difference
> > except for line numbers, so
> > 
> > Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> I noticed the remainder of of this series is now in Jason Cooper's irqchip
> tree.  Is anybody still taking care of SH?  If not I can funnel it
> through the MIPS tree.

Are the SH maintainers active?  I admit I know very little about the
arch.  I'm more than happy to pick it up and keep it with the rest of
the series, I just didn't want to step on toes...

thx,

Jason.
