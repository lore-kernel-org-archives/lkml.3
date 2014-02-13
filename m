Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaBMLHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:07:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbaBMLHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:07:37 -0500
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a
 platform driver
From: Jean Delvare <jdelvare@suse.de>
To: Laszlo Papp <lpapp@kde.org>
Cc: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CAOMwXhOv-as1W69wcSno49jEXsXWZZ7odnu8og-vgnDwRTJ4sA@mail.gmail.com>
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>
	 <20140213095817.GD32508@lee--X1> <20140213111530.2a2b4982@endymion.delvare>
	 <CAOMwXhML8LvDCzmk1ZVT+7cARj9C3VtxERWBgOPM9vTc6qQXZQ@mail.gmail.com>
	 <CAOMwXhOv-as1W69wcSno49jEXsXWZZ7odnu8og-vgnDwRTJ4sA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Thu, 13 Feb 2014 12:07:32 +0100
Message-ID: <1392289652.29672.26.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laszlo,

Le Thursday 13 February 2014 à 10:46 +0000, Laszlo Papp a écrit :
> On Thu, Feb 13, 2014 at 10:38 AM, Laszlo Papp <lpapp@kde.org> wrote:
> > On Thu, Feb 13, 2014 at 10:15 AM, Jean Delvare <jdelvare@suse.de> wrote:
> >> Any change to the max6650 driver should go on top of his patch series
> >> to avoid conflicts:
> >>
> >> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041223.html
> >
> > As far as I can see, that patch set was not even tested, so how can it
> > go in? I was told that any patch should be _runtime_ tested, too.
> > Fwiw, I do not have time to test those personally, he would need to
> > find someone else if that requirement really holds true.

I find it _very_ funny that you dare to complain here, when you sent a
totally untested patch no later than 2 days ago:

http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041180.html

There's no way that patch can work.

And, actually, Guenter's patches have been reviewed and tested by
myself, to some degree (I don't have access to a physical MAX6650 or
MAX6651 chip so I used an emulation, which I think was good enough given
the nature of the changes.)

> > I would not really like to fix bugs appearing in that code to get my
> > features in.

I have no idea what you mean here.

> Also, since my change has been around for 2-3 months now, I would
> really prefer not to be forced to rewrite it again from scratch.

I'm sure Gunter would have preferred if you could write proper patches
so he wouldn't have to do it himself.

Seriously, nobody here cares about your personal preferences. You said
you want some significant changes done to the max6650 driver, it takes
many steps to get there, either you take them, or you can leave right
now. If you're not going to listen to (and subsequently obey) people who
have been working on this project for years and are well-known and
respected by the vast majority of their peers, then bye bye.

> Surely, you can wait with those, more or less, cosmetic non-runtime
> tested changes?

I see you once again failed to read (or understand) something I repeated
many times already. One of these changes (the one moving the hwmon
attributes from i2c device to hwmon device) is _mandatory_ to get your
own changes accepted. Guenter did you an immense favor by writing these
patches, so if anything you should be very grateful to him.

> This would impose me a lot of additional work again, and I personally
> do not see the benefit of it. In my book at least, feature is over
> internal polishing.

Change books then, yours is just wrong. Bug fixes come first, then
cleanups, then features. Adding features on top of ugly code is a pain
for everyone. Plus cleaning up the code helps you to understand it, so
I'd say this is time well invested. You should try, that would certainly
help you avoid some mistakes you did in the past.

I would like to add a more general comment on the way you behave with
the community and that has been bothering me for days. You apparently
act first and think second. I can no longer count the number of times
you replied to a post only to reply to yourself a few minutes later.
Last occurrence of this is in this thread: first reply from you at
11:38, and then an addition at 11:46, i.e. 8 minutes later. And you do
that all the time.

And it holds for patches too, for example.
http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041179.html
posted at 11:24, then
http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041180.html
v2 of the same posted at 11:28.

So please listen to this piece of advice: take your time. Think more,
and only act after you have thought thoroughly about everything. It will
save you a lot of trouble, and the community a lot of time.

Thanks,
-- 
Jean Delvare
Suse L3 Support

