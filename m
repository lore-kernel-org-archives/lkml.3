Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab3EFUi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:38:57 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:53532 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3EFUi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:38:56 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 May 2013 16:38:56 EDT
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Mon, 6 May 2013 16:31:18 -0400
To: Rob Landley <rob@landley.net>
Cc: Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
        James Courtier-Dutton <james.dutton@gmail.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        David Goodenough <david.goodenough@btconnect.com>,
        debian-arm@lists.debian.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Subject: Re: device tree not the answer in the ARM world [was: Re: running
 Debian on a Cubieboard]
Message-ID: <20130506203118.GK28282@csclub.uwaterloo.ca>
References: <CAPweEDwZrXQ4Wqw6_-YvmR7uNxWWNvE_c0-8UMuEhFzYW-BZWQ@mail.gmail.com>
 <1367870518.18069.211@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367870518.18069.211@driftwood>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 03:01:58PM -0500, Rob Landley wrote:
> And economies of scale are everything to hardware cost. Unit volume
> amortizes the development (and often licensing) costs down, in the
> long run who has the highest unit volume has the cheapest product.
> Being able to reuse off the shelf components is nice, but being able
> to repurpose existing high-volume smartphone packages semi-verbatim
> is nicer.
> 
> Also, your cheap little one-off product tends to have a lifespan
> measured in months. Especially since the most common southeast asian
> business model used to be something like "develop thing through
> shell company, fill inventory channel with product, launder profits
> through series of shell companies that patent infringement suits
> can't burrow through in a reasonable amount of time, dissolve
> company and shell companies before product ever winds up on store
> shelves leaving nobody to sue, re-hire the same set of engineers at
> new shell company, rinse, repeat.'
> 
> (Has this changed recently? I haven't really been paying attention
> since smartphones started replacing the PC the way the PC replaced
> minicomputers and mainframes, so the billion seats of Android are
> more interesting than the rest of the embedded space combined. I did
> a talk about that at ELC if you're bored:
> http://www.youtube.com/watch?v=SGmtP5Lg_t0 )

Probably still true.

> Which is why this hardware tends to ship with crappy, unusable,
> unsupported software. Because actually programming the sucker is an
> afterthought, and the company that created it won't be _around_ long
> enough to support it, because if it did it would be around long
> enough to be sued for "we patented breathing, pay up".
> 
> The reason we should care about this business model when the vendors
> don't is...?

I am getting the impression that we should ignore the cell phones given
they seem to be thoroughly ignoring their customers and everyone else
anyhow.  If we then focus on the devices that perhaps do care to be around
for a while and supported, we might actually have a manageable problem.
Who knows maybe at some point the cell phone makers will smarted up and
realize there is a market in having happy long term customers and join in.

> If you use a DT-based kernel you can upgrade to new vanilla releases
> for 5 years, and if you don't you probably never upgrade to a new
> version ever.

Sure looks that way to the majority of devices.

> Except the type of company you're describing won't be around long
> enough to provide an upgrade. They'll just tell you to buy a new one
> next year, from the same engineers working at new shell company du
> jour (which has already dissolved by the time product hits the
> shelves; this stuff can get outsourced and rebadged with other
> people's branding to disguise the churn but the short-term thinking
> is there for a _reason_).
>
> You realize that nobody except Samsung and Apple is currently making
> money in the smartphone space, right?
> 
> http://www.slate.com/blogs/moneybox/2013/04/02/smartphone_profit_shares_apple_and_samsung_have_the_whole_pie.html
> 
> And that they're doing better because neither one is as stupid as
> the companies you're describing?
> 
> http://www.bbc.co.uk/news/business-22036876
> 
> Yes, you can install Linux on cheap plastic pieces of nonstandard
> crap that have already ceased production before you can buy one.
> It's about as interesting as hollowing out a Furby and making it run
> Linux.

It does look like a better model, although they do have to work at doing
things well, unlike the makers of cheap junk.

> Which means that nothing we do matters to them anyway, they will
> never listen to us, we have no reason to listen to them, and they
> can basically piss off and stop bothering us? (Which was pretty much
> what Linus asked?)
> 
> Meanwhile, we pay attention to the companies that have a future, and
> not the modern gold rush iteration. (Before the smartphone we had
> the digital watch boom, the calculator boom, the incomptible 8-bit
> microcomputer boom, the dot-com pets.com/drkoop.com era... this is
> not a new thing, and unix has lived through all of it.)
> 
> Don't get me wrong: I'm happy to provide them with good tools. But
> making their needs a primary design consideration when it comes to
> sustainability and upgrade paths is wrong. A company that lives or
> dies based on half a cent in component selection is NOT worried
> about an upgrade path. It's making something disposable, and the
> company itself is disposable.
> 
> And neither is the same as the quality or sustainability of the
> resulting software. But if the product line will be be discontinued
> three months after its introduction, who cares about being able to
> maintain anything?

Sounds good to me.  Those that think devicetree will never work can go
do whatever they want with the hardware they have from the makers of
cheap junk with no expected lifetime in the market.  The rest of us can
go focus on making something efficient and usable long term.

-- 
Len Sorensen
