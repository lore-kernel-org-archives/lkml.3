Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3ICP03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:26:29 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45390 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab3ICP01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:26:27 -0400
Date: Tue, 3 Sep 2013 08:26:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Liqin Chen <liqin299@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Remove support for score architecture
Message-ID: <20130903152617.GA20159@roeck-us.net>
References: <1377914435-24206-1-git-send-email-linux@roeck-us.net>
 <CAF0htA6gW3h82p2sBBpFEi4s0MkQ-NUn79VXWLieZmYNuUPA6w@mail.gmail.com>
 <5224247E.3050600@roeck-us.net>
 <CAF0htA6sYZOvLt_JczGpfjEJZep6cAquJV9tZ2FwYC+C6ngzXQ@mail.gmail.com>
 <5224CB12.50206@roeck-us.net>
 <CAFP0e=Gio_o6QFboVGe3aBCM0zFrsrJuNBthj63RXr+=SDPp7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFP0e=Gio_o6QFboVGe3aBCM0zFrsrJuNBthj63RXr+=SDPp7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 12:54:06PM +0800, Liqin Chen wrote:
> 2013/9/3 Guenter Roeck <linux@roeck-us.net>
> 
> > On 09/02/2013 08:18 AM, Lennox Wu wrote:
> >
> >> Before we start the development of the S+core, Sunplus had licensed
> >> ARM and MIPS. We develop S+core for other reason such as the price.
> >> Some products on the web of Sunplus adopt S+core , for example
> >> the SPV7050.(http://w3.sunplus.**com/products/spv7050.asp<http://w3.sunplus.com/products/spv7050.asp>)
> >> These products
> >> could still be bought from the market. Some high-end products adopt
> >> ARM or MIPS. So, there is no conflict for a company adopts multiple
> >> architectures.
> >>
> >> As I said, we recognize that we rarely update because of the limited
> >> applications and rare requests from customers. Maybe we don’t
> >> understand the culture enough; we think that it is unnecessary if we
> >> have no new bugs or new functions, the thought seems wrong. We can
> >> commit some patches in the near future.
> >>
> >>
> > The point is not about submitting patches, it is about maintaining the
> > code.
> > Even if you don't add functionality, one would expect that you ensure that
> > new kernel versions compile and run on your hardware.
> >
> > Since January 2012, 68 patches have been applied to arch/score, pretty
> > much all of them addressing kernel API changes or global cleanup.
> > Only two of them got an Ack by one of the score maintainers.
> > This strongly suggests that you don't keep track of what is going on,
> > and at the very least raises the question if you do compile and test
> > new kernel versions on a regular basis. Even if you do, no one knows
> > about it, because ....
> >
> > As part of this process, I would expect the architecture maintainer to
> > accept incoming patches, test the same, and send pull requests to Linus.
> > The last time this happened was early 2011; since then all score patches
> > were sent to Linus through Andrew and a few other maintainers.
> > Actually, I don't see many signoffs from a score maintainer at all,
> > even from the very beginning.
> >
> > As pointed out, the MAINTAINERS entry for score points to a
> > non-existing domain, as does the e-mail address of one of the
> > maintainers.
> >
> > I would not call that "maintained".
> >
> 
> 
> Hi Al Viro, Guenter Roeck, Arnd Bergmann and all,
> 
> I still supports the S+core team to maintain their codes, although I
> left sunplus co. in 2011.
> 
> I keep reading the mailing list and testing these patches for S+core,
> I think the main problems are they have not echoed to any comments on
> score's questions. Maybe they think the current situation is good
> enough for their customers, and they don’t understand the rules of the
> group enough. Even so, they should update score code to the latest
> status, include my mail address.
> 
Updating your e-mail address, sending Ack or Nack replies to patches
for the architecture, and possibly sending pull requests to Linus
would be entirely up to you.

With neither you nor Suncore showing any activity, how is the kernel
community supposed to know if anyone maintains the architecture ?
Your e-mail pointing to a domain which no longer exists doesn't really
show much engagement.

Similar, if you _don't_ maintain the architecture anymore, it would be
prudent to let the community know by submitting a patch removing yourself
as maintainer.

> We will discuss how to maintain the code of S+core. However, if all of
> you and Linus also think the S+core should be removed from the
> upstream, we will do it.
> 
The main concern is that the architecture appears to be un-maintained in
practice. We don't know if the code even compiles, much less if it works
on any target hardware. We'll see if that situation changes.

Guenter
