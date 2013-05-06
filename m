Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3EFLEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 07:04:08 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36617 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab3EFLEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 07:04:07 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyne+nPjPWPByN+2C83oMehOHjDKNynpaniHAdz2KmsdQ@mail.gmail.com>
References: <CACxGe6vr1kh2yqnG6kpASBGDUQrC7taBu00VWu6VG+qCO2u9QA@mail.gmail.com>
 <CA+55aFw9fbZBiZDC25j4A50NmsYbpwV-wUfWMpE_D7bEXQ-XVg@mail.gmail.com>
 <20130503185148.600554bd@endymion.delvare> <CA+55aFx4Q6tSidW2sihZSjNyRYJLftT=s8QKpx6bCe_4M0hwug@mail.gmail.com>
 <20130503232242.5a0978ea@endymion.delvare> <CA+55aFyne+nPjPWPByN+2C83oMehOHjDKNynpaniHAdz2KmsdQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 May 2013 12:03:46 +0100
X-Google-Sender-Auth: rm8Qhi1Gjy39fiXAstTb09Jq_sw
Message-ID: <CACxGe6uhE-jpBFHDsWiK2+Ph4h+P5sJXH9z-iRTbS2RtpFrt3Q@mail.gmail.com>
Subject: Re: [git pull] GPIO for v3.10
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <samuel@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 10:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, May 3, 2013 at 2:22 PM, Jean Delvare <khali@linux-fr.org> wrote:
>>
>> It means that nobody test-compiled that tree with CONFIG_GPIO_UCB1400=m.
>
> And you are making that excuse exactly *why*?
>
> Especially when one of the commits was to allow it. Especially since
> the minimal you could expect is a "make allmodconfig" on the most
> common platform out there.
>
> Stop making excuses for bad behavior. Just admit that you guys screwed
> up rather than trying to soldier on.

Don't take it out on Jean. I screwed up. Jean did not. He wasn't even
remotely cause the problem and I appreciate that he has come to my
defence.

Yell at me if you like, but nobody else deserves the heat. Linusw did
something he didn't know he wasn't supposed to do. We've since talked,
it won't happen again, and he'll be a better maintainer for it. I
didn't do something I knew I was supposed to do because I trusted to
much in linux-next. There isn't an excuse for that and it won't happen
again either. I'm a lot more upset about that than about you freaking
out on me.

g.
