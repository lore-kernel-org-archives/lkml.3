Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaF2HVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 03:21:50 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35089 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbaF2HVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 03:21:49 -0400
Message-ID: <53AFBE8A.3020408@linux.com>
Date: Sun, 29 Jun 2014 09:21:46 +0200
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Gideon D'souza" <gidisrael@gmail.com>, Nick Krause <xerofoify@gmail.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cleanup of Kernel Bugzilla
References: <CAPDOMVg=L+spebzkckNpM0=9NY=meV=F_+ko+VJN_6M50NdNew@mail.gmail.com> <CAPDOMVjnROuS4D4E2B7=PxOZUB4YXHuFUKy5C9Y8Lm7gxN=N_Q@mail.gmail.com> <20140628201804.215ca896@alan.etchedpixels.co.uk> <CAPDOMVgYsQ_zDaBN-XPwN06OUvph9YGPRqn2gUoso4f5y2fZ=g@mail.gmail.com> <CAPNrq4yZTFXhPG4U5H4mqFw-xbvJL5Ht-XofwKTqApgM2jsAGQ@mail.gmail.com>
In-Reply-To: <CAPNrq4yZTFXhPG4U5H4mqFw-xbvJL5Ht-XofwKTqApgM2jsAGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Why was stable on Cc?]

On 06/29/2014 08:33 AM, Gideon D'souza wrote:
>> Why do you want an up to date list of kernel bugs?
>
> Even I'm a newbie and was looking for the same thing. I read
> eventually somewhere that bugzilla isn't maintained by kernel devs so
> I entirely gave up trying to find a bug to adopt.
>
> Many open source projects I've worked on (web frameworks mostly) have
> a well maintained list of bugs and tag the right ones "newbie" or
> "beginner suitable" and newbies can learn the ropes and get started
> easy. Even chromium has a "GoodFirstBug" tag for newbies.

I think that is because they are relatively young and they are generally
used for one direct purpose. The kernel has to make sure it works in a lot
of different situations and hence a lot of different bugs arise.

The kernel is old, and hence most of the JuniorJobs (as KDE calls them)
are either already fixed, or fixed right on the spot when they are discovered.

>
> With the linux kernel not only doesn't anything exist, the project
> itself is so bloody hard right, kernel programming, most of the
> bugzilla bugs I can barely understand let alone even begin to deduce
> what is going on. Now given that the list itself isn't maintained
> makes things extremely hard.

There are still methods to extract various unresolved bugs from the
bugzilla though. Look in any subsystem you find delicious and then
just sort the bugs by the date they were modified. This will yield
a list of nice fresh bugs along with some recently fixed bugs.

>
> Thanks @Nick for bringing this up. I would love to help you clean up
> the bugs, give me an email of any ideas you have on how to start.
>

I brought this up as well on the Kernel Summit list. There wasn't any
feedback on this :-), I guess there are some maintainers who care about
bugzilla, but the rest (and the majority probably) does not care.

I tend to think that even if we clean up the bugzilla, it will only be a
question of time until it gets to the state that it is in now.

Thanks,
     Levente Kurusa
