Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400Ab3ECVW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:22:56 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:4395 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934386Ab3ECVWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:22:55 -0400
Date: Fri, 3 May 2013 23:22:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [git pull] GPIO for v3.10
Message-ID: <20130503232242.5a0978ea@endymion.delvare>
In-Reply-To: <CA+55aFx4Q6tSidW2sihZSjNyRYJLftT=s8QKpx6bCe_4M0hwug@mail.gmail.com>
References: <CACxGe6vr1kh2yqnG6kpASBGDUQrC7taBu00VWu6VG+qCO2u9QA@mail.gmail.com>
	<CA+55aFw9fbZBiZDC25j4A50NmsYbpwV-wUfWMpE_D7bEXQ-XVg@mail.gmail.com>
	<20130503185148.600554bd@endymion.delvare>
	<CA+55aFx4Q6tSidW2sihZSjNyRYJLftT=s8QKpx6bCe_4M0hwug@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013 09:56:09 -0700, Linus Torvalds wrote:
> On Fri, May 3, 2013 at 9:51 AM, Jean Delvare <khali@linux-fr.org> wrote:
> >
> > The real problem here is that two patches which depended on each other
> > went to you through 2 different maintainer trees (mfd maintained by
> > Samuel Ortiz and gpio maintained by Grant L. & Linus W.), and the git
> > pull requests reached you in the wrong order. That doesn't make us all
> > irresponsible and lame contributors/maintainers, does it?
> 
> F*ck yes it does.
> 
> It means that NOBODY EVEN TEST-COMPILED THE TREE THAT GOT SENT TO ME.
> 
> WTF?

It means that nobody test-compiled that tree with CONFIG_GPIO_UCB1400=m.

> If that's not "irresponsible and lame", I don't know what the hell is.

Hell, n.   1. The place or state of punishment of the wicked after
death.  2. A world where people volunteering to maintain kernel
subsystems get fewer, because they received more blame for their casual
mistakes than praise for their thankless work.

-- 
Jean Delvare
