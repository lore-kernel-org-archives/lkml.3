Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390AbaGWUpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:45:13 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62821 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaGWUpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:45:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140722092757.GA8796@amd.pavel.ucw.cz>
References: <1404564682-21983-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140721212527.GC3824@amd.pavel.ucw.cz>
	<CAFo99gYhrNR68mdJY=fn1x-+4U=6gdv=C4-Xn-w-YJAPSa5bBQ@mail.gmail.com>
	<20140722092757.GA8796@amd.pavel.ucw.cz>
Date: Wed, 23 Jul 2014 22:37:40 +0200
Message-ID: <CAFo99gZfTLwSGikUa_nnmvJOBvzaOFJjEDmKbbJqjGgYZ7Y+GA@mail.gmail.com>
Subject: Re: [PATCH] video: fbdev: uvesafb.c: Cleaning up variable that is
 never used
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Pavel Machek <pavel@ucw.cz>
Cc: Joe Perches <joe@perches.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Evgeniy Polyakov <zbr@ioremap.net>, Wang YanQing <udknight@gmail.com>,
        Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        David Fries <David@fries.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

There is a lot in what you say.
In the beginning I send in a remark to the maintainer. It happened
absolutely nothing.

When I send out a patch that code is not used, then this code will be
reviewed. Which is the main purpose!

However, agree that this was perhaps an unusually clear solution.
I submit such a patch now.

Kind regards
Rickard Strandqvist


2014-07-22 11:27 GMT+02:00 Pavel Machek <pavel@ucw.cz>:
> On Tue 2014-07-22 11:16:58, Rickard Strandqvist wrote:
>> Hi
>>
>> Sure, I agree. But as I thought that I would not change
>> currentfunctionality, I would increase the chance that the patches were
>> included. And it would of course also clarify this type of problem.
>
> I'm trying to say that getting rid of the variables without changing
> functionality might be wrong thing to do, for example in this case. It
> looks like error handing is missing by mistake, and you are removing
> traces saying that error handing is required here.
>
> Dunno. Perhaps don't push patches where solution is not obvious?
>
> Or push them but mark the place with fixme?
>
>                                                                         Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
