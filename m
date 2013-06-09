Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3FIWnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 18:43:41 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:61085 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3FIWnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 18:43:40 -0400
Date: Mon, 10 Jun 2013 00:45:44 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>,
        artem.bityutskiy@linux.intel.com, andrew@lunn.ch,
        Bill Pemberton <wfp5p@virginia.edu>, Jingoo Han <jg1.han@samsung.com>,
        linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mtd: orion_nand: Improve error handling in
 orion_nand_probe
Message-ID: <20130609224544.GB3963@debian>
References: <1370768902-20239-1-git-send-email-emilgoode@gmail.com>
 <CAHp75VftwuS4ZTFP5D90PhyzrAMoHVxDiSCg0jrMGp+r0eRfzA@mail.gmail.com>
 <20130609191732.GK28112@mwanda>
 <CAHp75VcOMUVtfgXOQ+cyVpJN-XS7=yO1H8+8Nnw+LCgYWp7RPw@mail.gmail.com>
 <20130609205747.GX23987@mwanda>
 <CAHp75VeDtfq3APDQsy2SP=wLrRPUJdVaBbfu4NcrWrC70wCebg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeDtfq3APDQsy2SP=wLrRPUJdVaBbfu4NcrWrC70wCebg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for not responding earlier, I was away from my computer.
Thanks for the review, I will send a second version that applies
on top of Andy's patch and fix that typo in the change log.

Best regards,

Emil

On Mon, Jun 10, 2013 at 12:15:22AM +0300, Andy Shevchenko wrote:
> On Sun, Jun 9, 2013 at 11:57 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Sun, Jun 09, 2013 at 10:27:03PM +0300, Andy Shevchenko wrote:
> >> On Sun, Jun 9, 2013 at 10:17 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >> > On Sun, Jun 09, 2013 at 08:15:20PM +0300, Andy Shevchenko wrote:
> 
> >> >> What about another patch (that I guess should go first)  that converts
> >> >> printk to dev_* or pr_*?
> >>
> >> > Huh, what?  Those are two totally unrelated things.  Emil's patch is
> >> > a bug fix.
> >>
> >> To be precise his patch is bugfix and cleanup at once.
> >> My proposal is to add a clean up patch.
> >
> > The printk idea isn't a bad one, it's just totally unrelated to what
> > the patch is doing.
> 
> I don't agree with word 'totally'. It touches probe function and
> shuffles code there.
> 
> >  You can't just randomly tell people to do a
> > bunch of work for no reason.  "Good bugfix, but before we apply it
> > you have to mow my lawn."
> 
> In this particular case I didn't think it's a big deal to fix 3 printfs.
> Anyway, see patch in the next message.
> 
> 
> --
> With Best Regards,
> Andy Shevchenko
