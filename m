Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3CCJXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 04:23:08 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:65377 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3CCJXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 04:23:02 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] Adds support for Open Firmware in MAX730x GPIO Driver
To: leroy christophe <christophe.leroy@c-s.fr>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Patrick Vasseur <patrick.vasseur@c-s.fr>
In-Reply-To: <51304ABD.9020706@c-s.fr>
References: <201302220926.r1M9Q3wV029855@localhost.localdomain> <CACRpkdY1M8w7o8S4idAx1JN-fc-t221qF_uwR5U9RBsBAn=Jhw@mail.gmail.com> <51304ABD.9020706@c-s.fr>
Date: Sat, 02 Mar 2013 21:16:56 +0000
Message-Id: <20130302211656.879443E21F5@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Mar 2013 07:29:17 +0100, leroy christophe <christophe.leroy@c-s.fr> wrote:
> 
> Le 01/03/2013 01:43, Linus Walleij a écrit :
> > On Fri, Feb 22, 2013 at 10:26 AM, Christophe Leroy
> > <christophe.leroy@c-s.fr> wrote:
> >
> >> This patch allows the use of the MAX730x Driver on systems using
> >> the Open Firmware platform format
> >>
> >> Signed-off-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> > (...)
> >>          /* bits_per_word cannot be configured in platform data */
> >> -       spi->bits_per_word = 16;
> >> +       if (spi->dev.platform_data)
> >> +               spi->bits_per_word = 16;
> > What about just fixing so you *can* specify that instead?
> > The comment looks more like a FIXME to me.
> Euh, ok, why not. But here the purpose of my patch is to allow using 
> this driver with of_platform in addition to platform.
> This FIXME is not mine, it was already existing in that driver.
> As of_platform can configure bits per word, the only thing I did is to 
> add a test in order to not apply this FIXME on the of_platform case.
> 
> Do you think my patch is not acceptable like this ?

I would like to know /why/ this specific hunk is necessary. I cannot
tell from the context. That's the sort of thing that is very helpful to
have in the commit description. Otherwise the patch looks fine.

g.
