Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbaDXQSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:18:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41450 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758507AbaDXQSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:18:37 -0400
Date: Thu, 24 Apr 2014 13:18:04 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Subject: Re: [PATCH 08/28] nios2: MMU Fault handling
Message-ID: <20140424161804.GG1735@arch.cereza>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-6-git-send-email-lftan@altera.com>
 <20140422143036.GD15745@arch.cereza>
 <CAFiDJ59KHkh549PBezijr-UektFQtQaZ_5fP5qqRvsVC-e2uxw@mail.gmail.com>
 <20140424152232.GD1735@arch.cereza>
 <CAFiDJ5-r1SW9qbE4Oghg4cTZUA_qu2RfBj0YLafcFVGweBctoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFiDJ5-r1SW9qbE4Oghg4cTZUA_qu2RfBj0YLafcFVGweBctoQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 25, Ley Foon Tan wrote:
> On Thu, Apr 24, 2014 at 11:22 PM, Ezequiel Garcia
> <ezequiel.garcia@free-electrons.com> wrote:
> >> > I found that it's useful to add some printing here, just as ARM
> >> > does. I carry this patch on my kernel:
> >> >
> >> > +               printk(KERN_INFO "%s: unhandled page fault (%d) at 0x%08lx, cause %ld\n",
> >> > +                      current->comm, SIGSEGV, address, cause);
> >> > +               show_regs(regs);
> >> >
> >> > Do you think we could do something like it? Maybe with a compile time option?
> >> Yes, this is useful debug message. I can add this.
> >> Prefer not to add new compile time option, I think this shouldn't
> >> happen frequently.
> >
> > No, it shouldn't happen frequently. You can take a look at what ARM does.
> > They use a DEBUG_USER compile-time option, much more complex than my silly
> > proposal.
> For now, we can print it always if this shouldn't happen frequently.
> Compile time option can be added later if we have more other debug
> stuff to print later.
> 

OK, sound sensible.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
