Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3EFUJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:09:46 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:44918 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab3EFUJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:09:44 -0400
Date: Mon, 06 May 2013 15:01:58 -0500
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
In-Reply-To: <CAPweEDwZrXQ4Wqw6_-YvmR7uNxWWNvE_c0-8UMuEhFzYW-BZWQ@mail.gmail.com>
	(from lkcl@lkcl.net on Mon May  6 07:08:44 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1367870518.18069.211@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 07:08:44 AM, Luke Kenneth Casson Leighton wrote:
> > I suppose that ARM multi-platform will never cover all ARM CPUs, but
> > the more it covers, the easier and cheaper it will be to work with  
> new
> > hardware and ARM.
> 
>  no.  no, no no and wrong.  absolutely dead wrong.  you're completely
> misunderstanding the economics of large and mass-volume product
> development.  the hardware cost is
> EEEEEEVVVEEERRRRRRYYYTTHHHHIIINNNNGGGG.

And economies of scale are everything to hardware cost. Unit volume  
amortizes the development (and often licensing) costs down, in the long  
run who has the highest unit volume has the cheapest product. Being  
able to reuse off the shelf components is nice, but being able to  
repurpose existing high-volume smartphone packages semi-verbatim is  
nicer.

Also, your cheap little one-off product tends to have a lifespan  
measured in months. Especially since the most common southeast asian  
business model used to be something like "develop thing through shell  
company, fill inventory channel with product, launder profits through  
series of shell companies that patent infringement suits can't burrow  
through in a reasonable amount of time, dissolve company and shell  
companies before product ever winds up on store shelves leaving nobody  
to sue, re-hire the same set of engineers at new shell company, rinse,  
repeat.'

(Has this changed recently? I haven't really been paying attention  
since smartphones started replacing the PC the way the PC replaced  
minicomputers and mainframes, so the billion seats of Android are more  
interesting than the rest of the embedded space combined. I did a talk  
about that at ELC if you're bored:
http://www.youtube.com/watch?v=SGmtP5Lg_t0 )

>  the software development cost because it is a one-off (non-recurring
> expense) is completely and utterly irrelevant.  again, see reply to
> oliver's message.

Which is why this hardware tends to ship with crappy, unusable,  
unsupported software. Because actually programming the sucker is an  
afterthought, and the company that created it won't be _around_ long  
enough to support it, because if it did it would be around long enough  
to be sued for "we patented breathing, pay up".

The reason we should care about this business model when the vendors  
don't is...?

> > Say, if a manufacturer has 20 different models of mobile phone out
> > there, all based on ARM.
> > Currently, they need a different kernel for each one. If they could
> > use the same kernel across all 20 models, that would reduce their
> > development costs considerably.
> 
>  let's do some maths.  let's say that the cost of re-using a DT-based
> kernel is $50k, but the custom development (not using DT) is $250,000.

If you use a DT-based kernel you can upgrade to new vanilla releases  
for 5 years, and if you don't you probably never upgrade to a new  
version ever.

Except the type of company you're describing won't be around long  
enough to provide an upgrade. They'll just tell you to buy a new one  
next year, from the same engineers working at new shell company du jour  
(which has already dissolved by the time product hits the shelves; this  
stuff can get outsourced and rebadged with other people's branding to  
disguise the churn but the short-term thinking is there for a _reason_).

>  let's say that you have to use a freescale $20 processor (iMX6 Dual)
> with that, because linaro is being paid $1m per year to help freescale
> to make devicetree work, and it gets them in on that
> one-kernel-across-20-models thing.
> 
>  so they work out the BOM, against the projected expenditure over say
> 2 years they expect to sell say 100 million phones.

You realize that nobody except Samsung and Apple is currently making  
money in the smartphone space, right?

http://www.slate.com/blogs/moneybox/2013/04/02/smartphone_profit_shares_apple_and_samsung_have_the_whole_pie.html

And that they're doing better because neither one is as stupid as the  
companies you're describing?

http://www.bbc.co.uk/news/business-22036876

Yes, you can install Linux on cheap plastic pieces of nonstandard crap  
that have already ceased production before you can buy one. It's about  
as interesting as hollowing out a Furby and making it run Linux.

>  do you see the point, james?  the cost of the software development is
> utterly, utterly, utterly irrelevant.

Which means that nothing we do matters to them anyway, they will never  
listen to us, we have no reason to listen to them, and they can  
basically piss off and stop bothering us? (Which was pretty much what  
Linus asked?)

Meanwhile, we pay attention to the companies that have a future, and  
not the modern gold rush iteration. (Before the smartphone we had the  
digital watch boom, the calculator boom, the incomptible 8-bit  
microcomputer boom, the dot-com pets.com/drkoop.com era... this is not  
a new thing, and unix has lived through all of it.)

Don't get me wrong: I'm happy to provide them with good tools. But  
making their needs a primary design consideration when it comes to  
sustainability and upgrade paths is wrong. A company that lives or dies  
based on half a cent in component selection is NOT worried about an  
upgrade path. It's making something disposable, and the company itself  
is disposable.

>  but the amount of time taken on software development is *not* the
> same as the *cost* of the software development.

And neither is the same as the quality or sustainability of the  
resulting software. But if the product line will be be discontinued  
three months after its introduction, who cares about being able to  
maintain anything?

Rob