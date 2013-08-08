Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966601Ab3HHXGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 19:06:38 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40555 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966386Ab3HHXGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 19:06:37 -0400
Date: Thu, 8 Aug 2013 16:06:31 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, vikram186@gmail.com
Subject: Re: [PATCH v6 00/10] mtd: add datasheet's ECC information to
 nand_chip{}
Message-ID: <20130808230630.GA14434@norris.computersforpeace.net>
References: <1368760654-28754-1-git-send-email-b32955@freescale.com>
 <CAN8TOE-QvScbPUEPyrs-fYVQZmPu1h-wWX2hjz46KYtaWRckBw@mail.gmail.com>
 <520357DF.3030403@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520357DF.3030403@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 04:33:35PM +0800, Huang Shijie wrote:
> Hi Artem & Brian:
> >Hi Huang and others,
> >
> >On Thu, May 16, 2013 at 8:17 PM, Huang Shijie<b32955@freescale.com>  wrote:
> >>1.) Why add the ECC information to the nand_chip{} ?
...
> >Reviewed-by: Brian Norris<computersforpeace@gmail.com>
> >Tested-by: Brian Norris<computersforpeace@gmail.com>
> >
> >Thanks for the work Huang.
> >
> Could you please merge this patch set?

Thanks for the reminder. I haven't sorted through all the piles of
backed up stuff yet!

I made a few minor changes (for checkpatch.pl, regarding
__attribute__((packed)), and to make the style a little more
easily-read) and tested the generic stuff on my platform. I've pushed
the series to l2-mtd.git. Thanks for the patience!

Brian
