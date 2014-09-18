Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbaIRDDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:03:55 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64084 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbaIRDDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:03:54 -0400
Date: Wed, 17 Sep 2014 20:03:50 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Jiri Kosina <trivial@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-mtd@lists.infradead.org,
        "grmoore@altera.com" <grmoore@altera.com>,
        Huang Shijie <shijie8@gmail.com>
Subject: Re: [PATCH v3 0/7] mtd: denali: A collection of trivial coding style
 fixes
Message-ID: <20140918030350.GC8127@brian-ubuntu>
References: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
 <20140917171308.GC1193@ld-irv-0074>
 <20140918113135.70D0.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918113135.70D0.AA925319@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 11:31:35AM +0900, Masahiro Yamada wrote:
> On Wed, 17 Sep 2014 10:13:08 -0700 Brian Norris <computersforpeace@gmail.com> wrote:
> > On Tue, Sep 16, 2014 at 08:04:18PM +0900, Masahiro Yamada wrote:
> > > Masahiro Yamada (7):
> > >   mtd: denali: fix the format of comment blocks
> > >   mtd: denali: remove unnecessary variable initializations
> > >   mtd: denali: remove unnecessary casts
> > >   mtd: denali: change the type of iterators to int
> > >   mtd: denali: remove a set-but-unused variable
> > >   mtd: denali: remove unnecessary parentheses
> > >   mtd: denali: fix indents and other trivial things
> > 
> > This series still doesn't apply to l2-mtd.git.
> 
> I resent the last three patches as v3.
> 
> v3 5/7 mtd: denali: remove a set-but-unused variable
> v3 6/7 mtd: denali: remove unnecessary parentheses
> v3 7/7 mtd: denali: fix indents and other trivial things
> 
> I confirmed they are applicable onto
> commit 93e3c8adf6fcf2204ca334237b92c7f8cdafce6f
> of l2-mtd.git
> 
> You said as follow:
> 
> On Mon, 15 Sep 2014 22:07:32 -0700
> Brian Norris <computersforpeace@gmail.com> wrote:
> 
> > > Is there a chance for me to resend 5/7 to include this fix?
> > > Or is it too late?
> > 
> > Just send a new patch, please.

I mean "a new patch [on top of l2-mtd.git]", but I see that wasn't
clear.

> That's why I sent a new patch (v3 5/7) to replace
> commit 55ab9ec99bbfb4450dfa9bc0fd9e2c5052f4c3f7
> 
> 
> Did I do wrong?

Eh, just miscommunication from my end.

I don't like to back out patches for no good reason, but I suppose I can
back out patch 5/7 v2, and look at applying v3 instead.

Brian
