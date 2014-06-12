Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaFLFZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 01:25:42 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55579 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaFLFZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 01:25:39 -0400
Date: Thu, 12 Jun 2014 07:25:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Chris Ball <chris@printf.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [GIT PULL] MMC updates for 3.16-rc1
In-Reply-To: <CA+55aFyEbFLFWLKP5kHw85qTRNoviFk8LhivxXJgAMROdvJtsg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1406120724100.5160@axis700.grange>
References: <86ha3so84o.fsf@void.printf.net>
 <CA+55aFxBwteZeUHG+Z-cdLU_YCO4f8TDuYvGmXc0-v9M1H11+g@mail.gmail.com>
 <CA+55aFyEbFLFWLKP5kHw85qTRNoviFk8LhivxXJgAMROdvJtsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:R68iI6pgnx6hAdgV8iyjGTL9MOxREG9dXXfwegTRMUh
 q8paCZcp5DBMkZFZ1gU9hxHkqf45x/JH5eaNhqYEWu8F2mD8qS
 52L8lJMr4NbpAnH5Gk7WAwIgnIshjYupocr2bB+f7Z8omnPYuO
 eB3+8QktqpJELJZiel4Asf6zvg7axYRSkF7wba6gMVbLbH3Y/R
 2Sagoy9mwD5ckakiCVG4rqueloY1Dma5xCrPwP3kh6ikLTV1xh
 IwpQ/zua6BQee7Aay0qALD/JiMTz5c5CqioU2mUlDNQSJnHz7X
 FE3LJ+9zx3jKiOdFJncw4xXSPYb0c3imP2yMS4jX6Zivr86K8/
 gqgvS+r0k6mYtZsM9m3mXgEe3jOn2dvOiNm3xqsX+HKsCheVHs
 UzQk0StbMe+Wg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, 11 Jun 2014, Linus Torvalds wrote:

> On Tue, Jun 10, 2014 at 2:50 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Also, that new drivers/mmc/host/usdhi6rol0.c driver is one f*cking
> > noisy compile, and knisr certainly has never been tested in a 64-bit
> > environment. Please either fix it, or make it depend on BROKEN.
> 
> Guys? Seriously, if that driver isn't fixed, I'm going to mark it
> broken myself. It pretty much generates as many lines of warnings as
> the rest of my "allmodconfig" build combined.
> 
> It's extremely annoying, and the crazy warnings are likely to hide
> potential real problems elsewhere, so right now that driver has
> negative value. I do a lot of allmodconfig builds during the merge
> window, and I am not going to look at that warning much longer.
> 
> Fix it promptly, or it gets disabled.

I sent a patch a few hours ago: 
https://patchwork.kernel.org/patch/4338531/ Since it's only changing print 
format strings, it should be a trivial one to review, so, just waiting for 
Chris to pick it up and push it to you. Sorry about the trouble.

Thanks
Guennadi
