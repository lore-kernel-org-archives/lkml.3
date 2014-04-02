Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbaDBL5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:57:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48094 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758426AbaDBL5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:57:51 -0400
Date: Wed, 2 Apr 2014 04:57:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mdr@sgi.com, Ingo Molnar <mingo@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, pazke@donpac.ru,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 old platform removal for v3.15
Message-ID: <20140402115746.GL4284@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201404011852.s31Iqh12025199@terminus.zytor.com>
 <CAMuHMdUyG1fnhiTCiVpJd2m=DuYGMY92ydGVJhYw1ZCGtzxmRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUyG1fnhiTCiVpJd2m=DuYGMY92ydGVJhYw1ZCGtzxmRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040211-0928-0000-0000-000000DA641B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 10:01:00AM +0200, Geert Uytterhoeven wrote:
> On Tue, Apr 1, 2014 at 8:52 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> > David Rientjes (2):
> >       x86, apic: Remove support for ia32-based Unisys ES7000
> >       x86, apic: Remove support for IBM Summit/EXA chipset
> >
> > H. Peter Anvin (2):
> >       x86, platforms: Remove SGI Visual Workstation
> >       x86, platforms: Remove NUMAQ
> 
> Nice try on April the 1st! Nobody's gonna notice ;-)

No April fools in NUMAQ -- I gave it my Acked-by some time back.  ;-)

But yes, I don't know of anyone still running recent Linux on one of
those 15-year-old NUMAQ boxes, which by today's standards are old, slow,
and power-hungry.

							Thanx, Paul

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

