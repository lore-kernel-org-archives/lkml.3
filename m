Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3KOBLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 20:11:55 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37928 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3KOBLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 20:11:52 -0500
MIME-Version: 1.0
In-Reply-To: <527B68D7.2030403@ahsoftware.de>
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
	<5277D2C3.3020203@ahsoftware.de>
	<CAMuHMdUHcbHXa8YAvyRMG1+ww6yLZtiXdab47VT5EqY9oe_LtA@mail.gmail.com>
	<52782793.8040103@ahsoftware.de>
	<CAHW+f2J8L8ys-=Eszf4QQHOkr=vC9nVv63Pz4v_=wZNxWCjDvQ@mail.gmail.com>
	<527B68D7.2030403@ahsoftware.de>
Date: Thu, 14 Nov 2013 20:11:50 -0500
Message-ID: <CAHW+f2J3+qxiSzFgqiaKRcd=+3JatUTPMsC5KMPH_1m-yXwsrA@mail.gmail.com>
Subject: Re: Linux 3.12 released .. and no merge window yet .. and 4.0 plans?
From: Keith Curtis <keithcu@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 5:17 AM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 06.11.2013 14:42, schrieb Keith Curtis:
>
>> I don't know if you all should spend time working only on bugs, but I
>> believe more time should be spent on the bug *list*. There are many
>> users patiently waiting for the kernel to work for their computer. The
>> pleas for help can be read in the bug database. The data can be used
>> to determine the selective places in the code that need more
>> brainpower. Send in the cavalry! Some have been waiting for years. I'm
>> running into 9 kernel / X bugs on my new Lenovo Yoga 2 with 3.11.6. An
>> unprioritized buglist also discourages people from entering new, valid
>> ones. As the issue list gets in better shape, things will become a bit
>> more relaxed. Quality metrics around bug count and age can be useful.
>
>
> The problem with many bugs is, that workarounds don't get accepted.
>
> So the situation sometimes is that there is a driver which isn't that
> perfect and when you try to fix something, the patch is refused because it
> is as imperfect as the whole driver (even if the patch would cure some
> problems).
> So the only fix which won't be refused is a rewrite of the driver which
> often just isn't what people are willing to do.
>
> Regards,
>
> Alexander Holler
>

I think this explains some of the bugs, but not many. I think a better
explanation is that there aren't metrics tracked by anyone, some
important drivers are understaffed / abandoned, and some people don't
care about their bug count. Of course, in the housing construction
business, and other fields, if you don't do a conscientious job on
your punch list, you'd get fired. Bug count goals are a great
mechanism, better than flame-mails, of increasing the quality of a
product.

I just wrote a review of an Arch install on a Lenovo Yoga 2. I post a
link to those who may find it interesting:
http://keithcu.com/wordpress/?p=3270 but in general, I'm making the
kernel points I care about here so you might just find it rambling /
duplicative ;-)

Reviving the kerneloops service is a good idea but it isn't a great
quality metric on its own because it only catches a small fraction of
the problems users run into. Kerneloops problems could be
de-duplicated and then entered into bugzilla. Another good service
might be where you can upload your logs, and they get analyzed and
bugs reported. I see confusing and worrying errors filling up my SDD
(75MB / day.) I've fixed it via a tweak to journald.conf, but there
shouldn't be so much given that the hardware is brand-new and not
broken.

It is friendly on LKML given how busy everyone is, and partially that
is because any frustrated users of desktop Linux are inspired by it,
and therefore polite and don't nag. But the user-facing customer
service isn't super great right now so consider yourself lucky! I read
a line that a good way to judge an airline is by what happens *after*
they lose your luggage. By that standard Linux Airways needs to
improve a bit more somehow.

The battle between testers and developers goes almost as far back as
the one between the sexes, and werewolves vs vampires. Currently, the
users are beating the good guys. Send in the cavalry.

Regards,

-Keith
