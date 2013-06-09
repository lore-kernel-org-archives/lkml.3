Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3FIT1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 15:27:11 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40434 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3FIT1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 15:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130609191732.GK28112@mwanda>
References: <1370768902-20239-1-git-send-email-emilgoode@gmail.com>
	<CAHp75VftwuS4ZTFP5D90PhyzrAMoHVxDiSCg0jrMGp+r0eRfzA@mail.gmail.com>
	<20130609191732.GK28112@mwanda>
Date: Sun, 9 Jun 2013 22:27:03 +0300
Message-ID: <CAHp75VcOMUVtfgXOQ+cyVpJN-XS7=yO1H8+8Nnw+LCgYWp7RPw@mail.gmail.com>
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

On Sun, Jun 9, 2013 at 10:17 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sun, Jun 09, 2013 at 08:15:20PM +0300, Andy Shevchenko wrote:

[]

>> What about another patch (that I guess should go first)  that converts
>> printk to dev_* or pr_*?

> Huh, what?  Those are two totally unrelated things.  Emil's patch is
> a bug fix.

To be precise his patch is bugfix and cleanup at once.
My proposal is to add a clean up patch.

--
With Best Regards,
Andy Shevchenko
