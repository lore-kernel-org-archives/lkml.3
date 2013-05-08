Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3EHDpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 23:45:07 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:39625 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3EHDpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 23:45:05 -0400
X-Greylist: delayed 114182 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 23:45:05 EDT
Date: Tue, 07 May 2013 22:44:59 -0500
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
In-Reply-To: <CAPweEDw33eWGwkedvRHS3iCc2VRe7ho7SV-mjra-AgxNkC6REg@mail.gmail.com>
	(from lkcl@lkcl.net on Mon May  6 15:55:11 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1367984699.18069.213@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 03:55:11 PM, Luke Kenneth Casson Leighton wrote:
> On Mon, May 6, 2013 at 9:01 PM, Rob Landley <rob@landley.net> wrote:
> > You realize that nobody except Samsung and Apple is currently  
> making money
> > in the smartphone space, right?
> 
>  ok, ok - substitute "tablet" or "laptop" or "media centre" for
> "smartphone" . actually it doesn't matter what the product is, really.
>  the economics are the same: by the time you get to over 100 million
> units, the software development costs are somewhere around the 4th
> decimal place.

Actually it does. (That was the whole point of the video I posted a  
link to.)

mainframe -> minicomputer -> microcomputer -> smartphone

We've seen this dance before. The new thing will coalesce into a  
de-facto standard. (The interesting tablets are big phones, not small  
PCs. The "surface" is this generation's microvax.) All gets back to  
economies of scale again...

> > Yes, you can install Linux on cheap plastic pieces of nonstandard  
> crap that
> > have already ceased production before you can buy one. It's about as
> > interesting as hollowing out a Furby and making it run Linux.
> 
>  tell me about it.  now you know what drove me to come up with the
> Rhombus Tech initiative.  been there, rob, and decided i didn't like
> being fucked about, and decided to do something about it.

I'm attempting to hijack android and convince it to evolve into  
something usable (as I descibed in the ELC talk, starting around the 30  
second mark), but day job's leaving me spread a touch thin this month...

> >>  do you see the point, james?  the cost of the software  
> development is
> >> utterly, utterly, utterly irrelevant.
> >
> >
> > Which means that nothing we do matters to them anyway, they will  
> never
> > listen to us, we have no reason to listen to them, and they can  
> basically
> > piss off and stop bothering us?
> 
>  well, i'm listening.  through some _really_ random and extremely
> lucky - very very jammy - coincidences, i have access to some very
> very large factories in china.  we've been talking to them for some
> time, and because of the sheer overwhelming scales that they're
> dealing with, they reaaaaally like the advantages that 1) and 2) bring
> to them [above, right at the top of this message].
> 
>  mind you, it took us 18 months to explain it to them, but when we
> finally managed, they were really fired up.

Link above is the video of my speech trying to explain what I think's  
coming (and how I hope to take advantage of it). Video and outline:

   http://www.youtube.com/watch?v=SGmtP5Lg_t0
   http://landley.net/talks/celf-2013.txt

Only the first 30 seconds are about "what is toybox". The rest is _why_  
is toybox, I.E. attempting to steer the PC to smartphone transition so  
we have a shot at a a non-locked-down general purpose computing device.

>  and this is the opportunity that i'm acting as the gateway for *you*
> - free software developers - to gain access to, to make a difference
> and finally stop having to fuck around cleaning up after the mess made
> by the pathological profit-maximising corporations who get up our
> noses year on year.

Eh, pathological short term profit-maximizing loses out long-term to  
sustainable initiatives. We're not always sure what the

> > Meanwhile, we pay attention to the companies that have a future,  
> and not the
> > modern gold rush iteration. (Before the smartphone we had the  
> digital watch
> > boom, the calculator boom, the incomptible 8-bit microcomputer  
> boom, the
> > dot-com pets.com/drkoop.com era... this is not a new thing, and  
> unix has
> > lived through all of it.)
> 
>  i'll be sticking around and keeping an eye on the EOMA initiative for
> the next decade, see how far it gets.  that kind of long-term
> commitment
> 
> > Don't get me wrong: I'm happy to provide them with good tools. But  
> making
> > their needs a primary design consideration when it comes to  
> sustainability
> > and upgrade paths is wrong.
> 
>  indeed.
> 
> >A company that lives or dies based on half a
> > cent in component selection is NOT worried about an upgrade path.  
> It's
> > making something disposable, and the company itself is disposable.
> 
>  whereas the EOMA initiative is at the complete opposite end of the
> spectrum.  and products based around the EOMA standards, although
> there is a cost overhead of e.g. around $6 in parts for EOMA-68, there
> is a whopping great saving of 30 to 40% to the customer when compared
> to other products *if* your end-user is prepared to swap / share CPU
> Cards between two products.  if they share the CPU Card between three
> products then the saving to them is even greater.

In theory, Moore's Law says that buys you... 9 months?

(At the low end I'm never quite sure where the fixed costs come to  
dominate. Moore's law was just about price/performance ratio, not about  
absolute price. We haven't gone down to disposable devices because at a  
certain point the battery and case cost more than the electronics...)

But as I mentioned in the video, smartphones have to be good _phones_  
to tap into the billion-unit niche.

>  not only that but rather than throw away an entire product just
> because a CPU Card is obsolete [to them] the end-user can either
> re-purpose the CPU Card in a slower product, or sell it on e-bay, or
> re-use it in a freedombox.... whatever they like.

A phone is a mass-produced consumer electronics device. Is "I can rip  
the guts out of my DVD player and re-use it" a commercially interesting  
statement?

>  what they *don't* have to do is put the entire product in landfill.
> 
>  etc. etc. i could go on about this at some length but i've already
> done so lots of times.

Link?

> >>  but the amount of time taken on software development is *not* the
> >> same as the *cost* of the software development.
> >
> >
> > And neither is the same as the quality or sustainability of the  
> resulting
> > software. But if the product line will be be discontinued three  
> months after
> > its introduction, who cares about being able to maintain anything?
> 
>  exactly.  so in this case, with EOMA-68, even if a CPU has a 3 month
> lifecycle, it's a 3 month lifecycle on *only* the CPU Card (not the
> entire product range), and in that 3 months that CPU Card sold 10
> times more than if it was used in only one single-board product.
> 
>  so to a factory making EOMA-68 CPU Cards with that 3-month-lifecycle
> CPU, it's still worth doing, and still worth doing well.
> 
>  so.  to summarise: have i made it clear, rob, that only by doing
> things like EOMA - which is basically about creating mandatory
> standards with device-tree in each product's EEPROM - does device-tree
> actually become *truly* useful?  if not, please do say so, because
> this is really important to get the message over to people.

20 years ago all the bespoke 8-bit machines were replaced by commodity  
PCs. Rather a lot of the bespoke embedded systems are going to be  
replaced by repurposed smartphone packages. But a smartphone package  
has to be a good phone in addition to whatever else it does, or else it  
won't tap into the economies of scale of this billion-unit niche.

Everything I had to say on this topic was in the ELC talk. That was on  
the _software_ side, not on the hardware side, but it might provide a  
useful framework...

Rob

P.S. Well, not _everything_. I never mentioned that Apple Airport was  
obviously Steve Jobs' solution to the display portion of the  
"smartphone as workstation" problem, I didn't hammer very hard on LLVM  
being primarily sponsored by Apple...