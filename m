Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaCPKRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 06:17:09 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:55298 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaCPKRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 06:17:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130715091230.GA8786@amd.pavel.ucw.cz>
References: <20110102103210.GA25662@core.coreip.homeip.net>
 <20110102225741.GX5480@const.famille.thibault.fr> <20110112182702.GA9168@core.coreip.homeip.net>
 <20111114040613.GA4992@type.famille.thibault.fr> <20121221003449.GA6999@type.youpi.perso.aquilenet.fr>
 <20130713093552.GU8252@type> <20130715091230.GA8786@amd.pavel.ucw.cz>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Sun, 16 Mar 2014 11:16:25 +0100
Message-ID: <CAHYPw2H94ej=FdqHAxXpyZt+34TwK1Qj7LWP_bMro-v3JREisg@mail.gmail.com>
Subject: Re: [PATCH] Route kbd LEDs through the generic LEDs layer
To: Pavel Machek <pavel@ucw.cz>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
        Richard Purdie <rpurdie@rpsys.net>,
        LKML <linux-kernel@vger.kernel.org>, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-07-15 11:12 GMT+02:00 Pavel Machek <pavel@ucw.cz>:
> Hi!
>
>> > > > > This permits to reassign keyboard LEDs to something else than keyboard "leds"
>> > > > > state, by adding keyboard led and modifier triggers connected to a series
>> > > > > of VT input LEDs, themselves connected to VT input triggers, which
>> > > > > per-input device LEDs use by default.  Userland can thus easily change the LED
>> > > > > behavior of (a priori) all input devices, or of particular input devices.
>> > > >
>> > > > Nice! Leds now have proper /sys interface.
>> > > >
>> > > > But... I boot up, switch from X to console, press capslock, and no
>> > > > reaction anywhere.
>> > >
>> > > Is it working without the patch?  Console-setup for instance is known to
>> > > have broken the capslock LED, which is precisely one of the reasons for
>> > > this patch, which will provide console-setup with a way to bring back
>> > > caps lock working properly.
>> >
>> > You are right, it was broken before.
>>
>> Ok. You then may want fix your setup by configuring your caps lock led
>> the way console-setup will be supposed to do in the future:
>>
>> echo ctrlllock > /sys/class/leds/vt::capsl/trigger
>
> And this indeed makes capslock led work on console, again. Nice!
>
> Richard, could we get this applied for 3.12 or something? It makes
> keyboard LEDs sane...
>
> Thanks,
>                                                                         Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

Hello, what happened with this patch? Is there any problem with accepting it?

-- 
Pali Rohár
pali.rohar@gmail.com
