Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab3ECVsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:48:51 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:38738 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3ECVst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130503232242.5a0978ea@endymion.delvare>
References: <CACxGe6vr1kh2yqnG6kpASBGDUQrC7taBu00VWu6VG+qCO2u9QA@mail.gmail.com>
	<CA+55aFw9fbZBiZDC25j4A50NmsYbpwV-wUfWMpE_D7bEXQ-XVg@mail.gmail.com>
	<20130503185148.600554bd@endymion.delvare>
	<CA+55aFx4Q6tSidW2sihZSjNyRYJLftT=s8QKpx6bCe_4M0hwug@mail.gmail.com>
	<20130503232242.5a0978ea@endymion.delvare>
Date: Fri, 3 May 2013 14:48:48 -0700
X-Google-Sender-Auth: vEwR8VXxS3kHWYLkMch0DaeeAE0
Message-ID: <CA+55aFyne+nPjPWPByN+2C83oMehOHjDKNynpaniHAdz2KmsdQ@mail.gmail.com>
Subject: Re: [git pull] GPIO for v3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <samuel@sortiz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 2:22 PM, Jean Delvare <khali@linux-fr.org> wrote:
>
> It means that nobody test-compiled that tree with CONFIG_GPIO_UCB1400=m.

And you are making that excuse exactly *why*?

Especially when one of the commits was to allow it. Especially since
the minimal you could expect is a "make allmodconfig" on the most
common platform out there.

Stop making excuses for bad behavior. Just admit that you guys screwed
up rather than trying to soldier on.

If this was some uncommon case like "it doesn't work on s390" or
"there was a subtle interaction with other changes", I'd be less
pissed off. But this was literally a commit that did *one* thing, and
one thing only ("driver can be compiled as a module") and nobody had
tested that *one* thing that the commit did.

That's a f*cking disgrace. That's not the kind of tree you should
expect me to be happy about pulling.

Stop making excuses for it. Really. It just makes you look even worse.
The only correct reply was the one that Grant already sent, which was
basically "sorry, that was wrong, my bad".

Next merge window I will have forgotten, and maybe people will have
learnt to do some minimal testing of the stuff they send me. In the
meantime, don't try to make it look like this was all ok.

                    Linus
