Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3EHIT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:19:27 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:52484 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab3EHITY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:19:24 -0400
MIME-Version: 1.0
In-Reply-To: <1367984699.18069.213@driftwood>
References: <CAPweEDw33eWGwkedvRHS3iCc2VRe7ho7SV-mjra-AgxNkC6REg@mail.gmail.com>
	<1367984699.18069.213@driftwood>
Date: Wed, 8 May 2013 09:19:23 +0100
X-Google-Sender-Auth: ppF0uQ4kC6qhVlog8eq5_aQzA2Y
Message-ID: <CAPweEDxB0X9==FZtSqv0NsOiAojjF7GRtKB-A7Hi-5We0_k81A@mail.gmail.com>
Subject: Re: device tree not the answer in the ARM world [was: Re: running
 Debian on a Cubieboard]
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: Rob Landley <rob@landley.net>
Cc: James Courtier-Dutton <james.dutton@gmail.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        David Goodenough <david.goodenough@btconnect.com>,
        debian-arm@lists.debian.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 4:44 AM, Rob Landley <rob@landley.net> wrote:

>>  whereas the EOMA initiative is at the complete opposite end of the
>> spectrum.  and products based around the EOMA standards, although
>> there is a cost overhead of e.g. around $6 in parts for EOMA-68, there
>> is a whopping great saving of 30 to 40% to the customer when compared
>> to other products *if* your end-user is prepared to swap / share CPU
>> Cards between two products.  if they share the CPU Card between three
>> products then the saving to them is even greater.
>
>
> In theory, Moore's Law says that buys you... 9 months?

 and 6 months in to that 9 months you bring out the next CPU Card, and
the next, and the next, and the next, and the next.

 there's a hell of a lot of history already behind the EOMA
initiatives.  i'm running this discussion down, btw - the point's been
made, and i'm inviting linux kernel developers who may not have been
aware of the initiative to be involved.

 for many people i know they're absolutely fed up of always playing
catch-up: if that's the case then this is your opportunity to make a
difference.


>>  not only that but rather than throw away an entire product just
>> because a CPU Card is obsolete [to them] the end-user can either
>> re-purpose the CPU Card in a slower product, or sell it on e-bay, or
>> re-use it in a freedombox.... whatever they like.
>
>
> A phone is a mass-produced consumer electronics device. Is "I can rip the
> guts out of my DVD player and re-use it" a commercially interesting
> statement?

 you've missed the point.  EOMA-68 CPU Cards are separately-sold
mass-volume *interchangeable* products, i.e. being packaged in legacy
PCMCIA housings they have the exact same advantages of PCMCIA except
now it's the *CPU* that's interchangeable between products.

 nobody in their right mind swaps the DVD electronics, they just buy
another DVD player.  including the mechanical part and the built-in
PSU, and the GPL-violating software running on it.

>>  what they *don't* have to do is put the entire product in landfill.
>>
>>  etc. etc. i could go on about this at some length but i've already
>> done so lots of times.
>
>
> Link?

links.  here is a small non-exhaustive list.

http://www.c2mtl.com/eye50/ideas/the-rhombus-tech-eoma-68-initiative/
http://rhombus-tech.net/articles/eoma68_in_education/
http://lkcl.net/articles/tiny.computers.txt
http://rhombus-tech.net/
http://linux-sunxi.org/EOMA68-A10
http://elinux.org/Embedded_Open_Modular_Architecture/EOMA-68
http://elinux.org/Embedded_Open_Modular_Architecture
http://rhombus-tech.net/community_ideas/kde_tablet/news/
http://rhombus-tech.net/allwinner_a10/news/
http://rhombus-tech.net/allwinner/a31/news/
http://rhombus-tech.net/freescale/iMX6/news/
http://rhombus-tech.net/jz4760/news/
http://lists.phcomp.co.uk/pipermail/arm-netbook/2013-April/007168.html
http://lkcl.net/articles/eoma.txt
http://hardware.slashdot.org/story/12/09/07/2322207/rhombus-tech-a10-eoma-68-cpu-card-schematics-completed
http://hardware.slashdot.org/comments.pl?sid=3102545&cid=41270525
http://slashdot.org/comments.pl?sid=3643131&cid=43435993
http://slashdot.org/comments.pl?sid=3643131&cid=43435805
http://slashdot.org/comments.pl?sid=3643131&cid=43435635
http://slashdot.org/comments.pl?sid=3643131&cid=43435507

that's probably enough.
