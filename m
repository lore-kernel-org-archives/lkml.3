Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3EIAZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 20:25:19 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:55587 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3EIAZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 20:25:17 -0400
Date: Wed, 08 May 2013 19:25:08 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: device tree not the answer in the ARM world [was: Re: running
 Debian on a Cubieboard]
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
Cc: James Courtier-Dutton <james.dutton@gmail.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        David Goodenough <david.goodenough@btconnect.com>,
        debian-arm@lists.debian.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
In-Reply-To: <CAPweEDxB0X9==FZtSqv0NsOiAojjF7GRtKB-A7Hi-5We0_k81A@mail.gmail.com>
	(from lkcl@lkcl.net on Wed May  8 03:19:23 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1368059108.18069.218@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 03:19:23 AM, Luke Kenneth Casson Leighton wrote:
> On Wed, May 8, 2013 at 4:44 AM, Rob Landley <rob@landley.net> wrote:
> 
> >>  whereas the EOMA initiative is at the complete opposite end of the
> >> spectrum.  and products based around the EOMA standards, although
> >> there is a cost overhead of e.g. around $6 in parts for EOMA-68,  
> there
> >> is a whopping great saving of 30 to 40% to the customer when  
> compared
> >> to other products *if* your end-user is prepared to swap / share  
> CPU
> >> Cards between two products.  if they share the CPU Card between  
> three
> >> products then the saving to them is even greater.

It's only "whopping great" if it allows them to lower the absolute cost  
of the product. If it just buys you a 30% cost savings in a niche with  
an 18 month half life of hardware depreciation, sheer inventory  
management can get you that much.

The big limit of moore's law is these days you should be able to 4 megs  
of memory for a nickel, and you can't. The overhead of slicing it that  
small dwarfs the cost of the actual component, the RATIO changes but  
the cheapest netbook is still $200 or so. They don't _make_ disks that  
store less than a gigabyte anymore.

I should be able to put together the equivalent of Linus's original  
1991 PC for under a dollar, and I can't. (Not unless I manage to  
manufacture several million of them.) I've been awaiting disposable  
computing for years, but it's not here yet.

If your savings of 30% to the customer just means their router has 2  
gigs of ram instead of 1 gig of ram but is the same price as the one on  
the next shelf because the fixed costs dominate and you added $6 to  
that...

> > In theory, Moore's Law says that buys you... 9 months?
> 
>  and 6 months in to that 9 months you bring out the next CPU Card, and
> the next, and the next, and the next, and the next.
> 
>  there's a hell of a lot of history already behind the EOMA
> initiatives.

At what point does that history become a downside? (We've had 20 "year  
of the Linux on the Desktop" announcements. Nobody pays any attention  
to new ones, too much crying wolf. Anyway, I explained in the video why  
that's a systemic problem in our development model, tangent...)

If I want a cheap plastic Linux system I can buy a raspberry-pi ($35)  
or pandaboard-black ($45 and the HDMI driver isn't a binary-only blob).  
Do these systems participate in your EOMA thing? Would they benefit  
from it if they did? If so, given your history, why don't they?

> > A phone is a mass-produced consumer electronics device. Is "I can  
> rip the
> > guts out of my DVD player and re-use it" a commercially interesting
> > statement?
> 
>  you've missed the point.

Agreed. That's why I keep asking, trying to figure out what the point  
is.

> EOMA-68 CPU Cards are separately-sold
> mass-volume *interchangeable* products, i.e. being packaged in legacy
> PCMCIA housings they have the exact same advantages of PCMCIA except
> now it's the *CPU* that's interchangeable between products.

More mass-volume than phones?

I'm trying to think of the last time I got a new nebook with legacy  
PCMCIA in it. It's been more than 5 years...

>  nobody in their right mind swaps the DVD electronics, they just buy
> another DVD player.  including the mechanical part and the built-in
> PSU, and the GPL-violating software running on it.

Yes, that was sort of my point. What's _different_? And how is this not
http://xkcd.com/927 ?

> >>  what they *don't* have to do is put the entire product in  
> landfill.
> >>
> >>  etc. etc. i could go on about this at some length but i've already
> >> done so lots of times.
> >
> >
> > Link?
> 
> links.

Links !> link. Links ! even = to link, actually. It's one of them  
marketing 101 things. (See "paradox of choice", "elevator pitch",  
"marketing hook"...)

You know how when you start a fire you have a spark, kindling, and THEN  
logs? You escalate? Or when somebody writes a book the first sentence  
gets them to read the first page, the first page gets them to read the  
first chapter, the first chapter gets them invested in the story so  
they read the rest of the book...

In marketing you earn five seconds of attention, use it to earn thirty  
seconds of attention, use that to earn five minutes of attention...

You had five minutes worth of my interest, but that was not a five  
minute list of links.

> http://www.c2mtl.com/eye50/ideas/the-rhombus-tech-eoma-68-initiative/
> http://rhombus-tech.net/articles/eoma68_in_education/

Ok, obvious from those first two links that rhombus-tech is behind it.  
(Never heard of 'em, which is a bad sign given this "history" you speak  
of.) So, rhombus-tech.net... And there is a FAQ! First question says  
your goal is to create synergy.

Yeah, I'm not too big into synergy, I generally stick with the diet  
Monster and Rockstar flavors, occasional Full Throttle citrus when I've  
got some diet mountain dew to mix it with (but that's not diet, and the  
sugar does bad things to my sinuses).

I don't think I'm the target audience here.

Rob