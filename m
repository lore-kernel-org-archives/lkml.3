Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3FIU7D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 16:59:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43483 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3FIU7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 16:59:01 -0400
Date: Sun, 9 Jun 2013 23:57:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Emil Goode <emilgoode@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        artem.bityutskiy@linux.intel.com, andrew@lunn.ch,
        Bill Pemberton <wfp5p@virginia.edu>, Jingoo Han <jg1.han@samsung.com>,
        linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mtd: orion_nand: Improve error handling in
 orion_nand_probe
Message-ID: <20130609205747.GX23987@mwanda>
References: <1370768902-20239-1-git-send-email-emilgoode@gmail.com>
 <CAHp75VftwuS4ZTFP5D90PhyzrAMoHVxDiSCg0jrMGp+r0eRfzA@mail.gmail.com>
 <20130609191732.GK28112@mwanda>
 <CAHp75VcOMUVtfgXOQ+cyVpJN-XS7=yO1H8+8Nnw+LCgYWp7RPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcOMUVtfgXOQ+cyVpJN-XS7=yO1H8+8Nnw+LCgYWp7RPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 10:27:03PM +0300, Andy Shevchenko wrote:
> On Sun, Jun 9, 2013 at 10:17 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Sun, Jun 09, 2013 at 08:15:20PM +0300, Andy Shevchenko wrote:
> 
> []
> 
> >> What about another patch (that I guess should go first)  that converts
> >> printk to dev_* or pr_*?
> 
> > Huh, what?  Those are two totally unrelated things.  Emil's patch is
> > a bug fix.
> 
> To be precise his patch is bugfix and cleanup at once.
> My proposal is to add a clean up patch.

The printk idea isn't a bad one, it's just totally unrelated to what
the patch is doing.  You can't just randomly tell people to do a
bunch of work for no reason.  "Good bugfix, but before we apply it
you have to mow my lawn."

regards,
dan carpenter
