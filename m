Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbaFLHRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:17:54 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:54334 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaFLHRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:17:52 -0400
Date: Thu, 12 Jun 2014 08:17:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Ball <chris@printf.net>, Mike Turquette <mturquette@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [GIT PULL] MMC updates for 3.16-rc1
Message-ID: <20140612071744.GA11421@lee--X1>
References: <86ha3so84o.fsf@void.printf.net>
 <CA+55aFxBwteZeUHG+Z-cdLU_YCO4f8TDuYvGmXc0-v9M1H11+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxBwteZeUHG+Z-cdLU_YCO4f8TDuYvGmXc0-v9M1H11+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Linus Torvalds wrote:

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
> 
> Don't you guys talk to each other? The Realtek driver is even marked
> as Acked-by Chris Ball in the MFD tree.

Yes, we do talk to each other.  Branch ib-mfd-mmc-memstick-3.16 was
created as a result.  Based on no facts at all, I'm guessing that the
shared (immutable) branch wasn't applied correctly in the MMC tree.

> Also, that new drivers/mmc/host/usdhi6rol0.c driver is one f*cking
> noisy compile, and knisr certainly has never been tested in a 64-bit
> environment. Please either fix it, or make it depend on BROKEN.
> 
> Grr.
> 
> Anyway, pulled, merged correctly, and pushed out..
> 
>                 Linus

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
