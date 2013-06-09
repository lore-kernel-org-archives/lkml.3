Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab3FIVP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 17:15:26 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:42217 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3FIVPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 17:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130609205747.GX23987@mwanda>
References: <1370768902-20239-1-git-send-email-emilgoode@gmail.com>
	<CAHp75VftwuS4ZTFP5D90PhyzrAMoHVxDiSCg0jrMGp+r0eRfzA@mail.gmail.com>
	<20130609191732.GK28112@mwanda>
	<CAHp75VcOMUVtfgXOQ+cyVpJN-XS7=yO1H8+8Nnw+LCgYWp7RPw@mail.gmail.com>
	<20130609205747.GX23987@mwanda>
Date: Mon, 10 Jun 2013 00:15:22 +0300
Message-ID: <CAHp75VeDtfq3APDQsy2SP=wLrRPUJdVaBbfu4NcrWrC70wCebg@mail.gmail.com>
Subject: Re: [PATCH] mtd: orion_nand: Improve error handling in orion_nand_probe
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Emil Goode <emilgoode@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        artem.bityutskiy@linux.intel.com, andrew@lunn.ch,
        Bill Pemberton <wfp5p@virginia.edu>, Jingoo Han <jg1.han@samsung.com>,
        linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 11:57 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sun, Jun 09, 2013 at 10:27:03PM +0300, Andy Shevchenko wrote:
>> On Sun, Jun 9, 2013 at 10:17 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> > On Sun, Jun 09, 2013 at 08:15:20PM +0300, Andy Shevchenko wrote:

>> >> What about another patch (that I guess should go first)  that converts
>> >> printk to dev_* or pr_*?
>>
>> > Huh, what?  Those are two totally unrelated things.  Emil's patch is
>> > a bug fix.
>>
>> To be precise his patch is bugfix and cleanup at once.
>> My proposal is to add a clean up patch.
>
> The printk idea isn't a bad one, it's just totally unrelated to what
> the patch is doing.

I don't agree with word 'totally'. It touches probe function and
shuffles code there.

>  You can't just randomly tell people to do a
> bunch of work for no reason.  "Good bugfix, but before we apply it
> you have to mow my lawn."

In this particular case I didn't think it's a big deal to fix 3 printfs.
Anyway, see patch in the next message.


--
With Best Regards,
Andy Shevchenko
