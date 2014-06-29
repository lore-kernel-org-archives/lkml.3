Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaF2Gd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 02:33:59 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:45006 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaF2Gd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 02:33:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVgYsQ_zDaBN-XPwN06OUvph9YGPRqn2gUoso4f5y2fZ=g@mail.gmail.com>
References: <CAPDOMVg=L+spebzkckNpM0=9NY=meV=F_+ko+VJN_6M50NdNew@mail.gmail.com>
 <CAPDOMVjnROuS4D4E2B7=PxOZUB4YXHuFUKy5C9Y8Lm7gxN=N_Q@mail.gmail.com>
 <20140628201804.215ca896@alan.etchedpixels.co.uk> <CAPDOMVgYsQ_zDaBN-XPwN06OUvph9YGPRqn2gUoso4f5y2fZ=g@mail.gmail.com>
From: "Gideon D'souza" <gidisrael@gmail.com>
Date: Sun, 29 Jun 2014 12:03:36 +0530
Message-ID: <CAPNrq4yZTFXhPG4U5H4mqFw-xbvJL5Ht-XofwKTqApgM2jsAGQ@mail.gmail.com>
Subject: Re: Cleanup of Kernel Bugzilla
To: Nick Krause <xerofoify@gmail.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, stable@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Why do you want an up to date list of kernel bugs?

Even I'm a newbie and was looking for the same thing. I read
eventually somewhere that bugzilla isn't maintained by kernel devs so
I entirely gave up trying to find a bug to adopt.

Many open source projects I've worked on (web frameworks mostly) have
a well maintained list of bugs and tag the right ones "newbie" or
"beginner suitable" and newbies can learn the ropes and get started
easy. Even chromium has a "GoodFirstBug" tag for newbies.

With the linux kernel not only doesn't anything exist, the project
itself is so bloody hard right, kernel programming, most of the
bugzilla bugs I can barely understand let alone even begin to deduce
what is going on. Now given that the list itself isn't maintained
makes things extremely hard.

Thanks @Nick for bringing this up. I would love to help you clean up
the bugs, give me an email of any ideas you have on how to start.

Regards,
Gideon

On Sun, Jun 29, 2014 at 8:34 AM, Nick Krause <xerofoify@gmail.com> wrote:
> Thanks that's fine , I am  new to kernel work , so a list of bugs would
> be very helpful in my helping out with debugging.
> Cheers Nick
>
> On Sat, Jun 28, 2014 at 3:18 PM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
>> On Fri, 27 Jun 2014 22:45:47 -0400
>> Nick Krause <xerofoify@gmail.com> wrote:
>>
>>> Do any of you use the kernel Bugzilla? If you do I was wondering if we
>>> can clean it up.
>>
>> Developers are generally focussed on fixing bugs. Also the way bugzilla
>> works a lot of developers don't close the bugs and the originators never
>> get around to it.
>>
>> Now if you want to clean up bugzilla then what would be really useful
>> (and probably quite tedious) is a list of all the bugs which end either in
>>
>> - confirmation it is fixed, but the bug is not closed
>>
>> - confirmation that it cannot be reproduced, but the bug is not closed
>>
>> - with a question asking for more information which has had no reply in
>>   say 3 months
>>
>> Given lists of bugs in those categories I can then go and zap them.
>>
>> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
