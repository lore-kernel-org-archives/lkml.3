Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaIPFHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 01:07:37 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59909 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaIPFHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 01:07:36 -0400
Date: Mon, 15 Sep 2014 22:07:32 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-mtd@lists.infradead.org, Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>,
        Jiri Kosina <trivial@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v2 0/7] mtd: denali: A collection of trivial coding style
 fixes
Message-ID: <20140916050732.GB18093@brian-ubuntu>
References: <1410228117-14820-1-git-send-email-yamada.m@jp.panasonic.com>
 <20140916003620.GA1193@ld-irv-0074>
 <20140916111154.58F0.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140916111154.58F0.AA925319@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masahiro,

On Tue, Sep 16, 2014 at 11:11:58AM +0900, Masahiro Yamada wrote:
> On Mon, 15 Sep 2014 17:36:20 -0700 Brian Norris <computersforpeace@gmail.com> wrote:
> > On Tue, Sep 09, 2014 at 11:01:50AM +0900, Masahiro Yamada wrote:
> > > Changes in v2:
> > >   - Join quotes strings into a single line
> > > 
> > > Masahiro Yamada (7):
> > >   mtd: denali: fix the format of comment blocks
> > >   mtd: denali: remove unnecessary variable initializations
> > >   mtd: denali: remove unnecessary casts
> > >   mtd: denali: change the type of iterators to int
> > >   mtd: denali: remove a set-but-unused variable
> > >   mtd: denali: remove unnecessary parentheses
> > >   mtd: denali: fix indents and other trivial things
> > > 
> > >  drivers/mtd/nand/denali.c | 562 +++++++++++++++++++++++++---------------------
> > >  1 file changed, 303 insertions(+), 259 deletions(-)
> > 
> > Pushed patches 1 to 5 to l2-mtd.git. Thanks!
> > 
> > Patch 6 has a conflict with another fix already in l2-mtd.git. Can you
> > rebase and resend?
> 
> Sorry for my ignorance, but where can I find l2-mtd.git?

git://git.infradead.org/l2-mtd.git

> In my understanding, the subsystem repositories should be documented
> in MAINTAINERS, so I looked for it but just found
> T:    git git://git.infradead.org/linux-mtd.git.
> I do not think it is the one you mentioned.

Sorry, apparently l2-mtd.git is not in MAINTAINERS. It historically has
been a kind of queue for the official repo (linux-mtd.git), especially
when work was split up between two people. I handle most of it now.

I guess it should be in MAINTAINERS, though, since most people will need
to base patches on it. I just sent a patch to add it.

> > BTW, my automatic build tests show that there's at least one other
> > 'unused' warning left, in case you want to tackle it too:
> > 
> >     drivers/mtd/nand/denali.c: In function ‘denali_read_page_raw’:
> >     drivers/mtd/nand/denali.c:1221:11: warning: variable ‘irq_status’ set but not used [-Wunused-but-set-variable]
> >           uint32_t irq_status;
> > 
> 
> You are right.
> (What is odd enough is this warning was not displayed on my build test.
> I do not know why.)

I enabled extra warnings. I think you can get most of those with 'make
W=1'.

> Is there a chance for me to resend 5/7 to include this fix?
> Or is it too late?

Just send a new patch, please.

Thanks,
Brian
