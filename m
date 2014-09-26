Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaIZNRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:17:52 -0400
Received: from sym2.noone.org ([178.63.92.236]:38512 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbaIZNRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:17:49 -0400
Date: Fri, 26 Sep 2014 15:17:46 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ley Foon Tan <lftan@altera.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP
Message-ID: <20140926131746.GA3279@distanz.ch>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
 <12538756.JybTPMqFHj@wuerfel>
 <CAFiDJ5-bo_WOz6JockX_BaX0_O0D=+8PjKx7gys-ySKA2KMOaw@mail.gmail.com>
 <3608975.MxU44B73lk@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3608975.MxU44B73lk@wuerfel>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-24 at 13:10:00 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 24 September 2014 18:57:54 Ley Foon Tan wrote:
> > On Wed, Sep 24, 2014 at 6:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Wednesday 24 September 2014 18:18:50 Ley Foon Tan wrote:
> > >> On Tue, Sep 23, 2014 at 6:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > >> > On Tuesday 23 September 2014 18:20:08 LF.Tan wrote:
> > >> >> Hi Arnd
> > >> >>
> > >> >> Are you okay with this generic futex in asm-generic?
> > >> >>
> > >> >
> > >> > Yes, this looks good. Remind me again who need this, would it make
> > >> > sense to merge this through an architecture-specific tree for
> > >> > whichever architecture can benefit from it?
> > >> What is the common practice for this?
> > >> Do you mean merge with nios2 or other arch, eg m68k?
> > >
> > > I mean do it as part of the nios2 patches.
> > I am okay with this.
> > Do I need to get ACK for all patches in order for nios2 merge into mainline?
> > Thanks.
> > 
> 
> Please add my 'Acked-by: Arnd Bergmann <arnd@arndb.de>' to this patch
> once Thomas is ok with it. I think we had concluded already that it
> was correct when we talked about it last time, but he doesn't seem
> convinced yet so I want to wait for his reply.
> 
> You definitely need an Ack for all patches touching code outside of
> arch/nios2, from the respective maintainers. For the nios2 code,
> having as many acks as you can helps, and I should probably take
> a last look so I can ack the pull request when you send it.

Speaking of the nios2 part: I'm the author of some parts of this code,
but now also reviewed this series (or rather, intend to do so for the
few remaining patches I didn't review yet).

What is the appropriate way to account for this? Is Reviewed-By still OK? I
guess I won't be considered an entirely neutral reviewer ;)

Cheers
Tobias
