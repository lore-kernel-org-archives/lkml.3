Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaFJXrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:47:43 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37025 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaFJXrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:47:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Chris Ball" <chris@printf.net>, "Lee Jones" <lee.jones@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CA+55aFxBwteZeUHG+Z-cdLU_YCO4f8TDuYvGmXc0-v9M1H11+g@mail.gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
References: <86ha3so84o.fsf@void.printf.net>
 <CA+55aFxBwteZeUHG+Z-cdLU_YCO4f8TDuYvGmXc0-v9M1H11+g@mail.gmail.com>
Message-ID: <20140610234737.6562.43399@quantum>
User-Agent: alot/0.3.5
Subject: Re: [GIT PULL] MMC updates for 3.16-rc1
Date: Tue, 10 Jun 2014 16:47:37 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds (2014-06-10 14:50:59)
> On Tue, Jun 10, 2014 at 12:51 PM, Chris Ball <chris@printf.net> wrote:
> >
> >  These patches have been tested in
> > linux-next, and there are three minor conflicts which I've resolved on
> > my mmc-updates-for-3.16-rc1-merged branch.
> 
> Your merged branch is incorrect as far as I can tell, and dropped
> commit a8246fedacad ("dmaengine: omap: hide filter_fn for built-in
> drivers").
> 
> And I'm not sure why the sunxi driver (by David Lanzendörfer) and the
> Realtek driver (by Roger Tseng) got merged in two different trees.
> It's clearly the same patches and drivers, but I got them first
> through the MFD tree (Realtek) and the clock tree (sunxi) trees and
> now the MMC tree.

Bummer. The sunxi mmc driver came through the clock tree to handle a
linux-next merge issue. Pics or it didn't happen:

https://lkml.org/lkml/2014/6/2/696

Regards,
Mike

> 
> Don't you guys talk to each other? The Realtek driver is even marked
> as Acked-by Chris Ball in the MFD tree.
> 
> Also, that new drivers/mmc/host/usdhi6rol0.c driver is one f*cking
> noisy compile, and knisr certainly has never been tested in a 64-bit
> environment. Please either fix it, or make it depend on BROKEN.
> 
> Grr.
> 
> Anyway, pulled, merged correctly, and pushed out..
> 
>                 Linus
