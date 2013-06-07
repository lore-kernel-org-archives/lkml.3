Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3FGICr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:02:47 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34617 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3FGICo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:02:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130606131042.GN18614@n2100.arm.linux.org.uk>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<1370475609.20454.44.camel@localhost>
	<CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
	<1733666.lHUBcfUXq9@flatron>
	<CAPweEDzYLDzh_-OWU61dtVhajZ40QpQgZKHFYDsh3FgF=r9_ag@mail.gmail.com>
	<20130606131042.GN18614@n2100.arm.linux.org.uk>
Date: Fri, 7 Jun 2013 09:02:43 +0100
Message-ID: <CAPweEDyYt+pN+UaFuqWL5RrHpyuq_4So-tArmx3dr=0wLS+hwQ@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        linux-arm-kernel@lists.infradead.org, debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 2:10 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> If companies are going to go off and invent the square wheel, and that
> makes *them* suffer the loss of being able to merge back into the
> mainline kernel, thereby making *their* job of moving forward with
> their kernel versions much harder, then yes, we *are* happy.

 russell: they have more employees than sense :)  they also don't have
any idea of what they *should* be doing, so this is an opportunity to
educate them.

 they're not feeling any pain: they just employ more chinese
developers and substitute bodies for time and common-sense.

 also, in this particular case, thanks to their script.fex system when
i said they only need to develop one kernel and one u-boot i really
wasn't kidding around: they really have got to the point which
everyone else dreams of with device-tree [admittedly by limiting the
product range that their clients can play with, but that product range
has huge returns, so they're still happy].

> Companies will always do idiotic things; it's *them* and their users
> who have to live with the results of that bad decision making process.

 russell: the decision process they've made is actually an extremely
effective one.

> Eventually, the pain of being outside the mainline kernel will become
> too great, especially if their users demand things like kernel upgrades
> from them.  Eventually, they will change.
>
> And no, this isn't an intransigent position.  This is reality given
> that ARM already has way too much code in the Linux kernel and we're
> trying to reduce that through the use of technologies like DT.  The
> last thing we need right now is for another "DT" like implementation
> to come along which is only used on a minority of platforms - even if
> the platform it is used on is successful.
>
> The way this works is this:
> - you either go with the policies which are set, or

 .... which they weren't consulted on, it has to be pointed out.

> - you change the policy as a whole because you have a technically
>   superior solution

 i believe they have a technically more *successful* solution. whether
it's more appropriate in a wider context is another matter.

 here we have a key to the crux of the problem: the linux kernel
maintainers have to cater for _everyone_.  with no funding or
incentive from the major contributors to work with them.  hmmm....

> What that means in this case is either you adopt DT, or you convince
> everyone that DT isn't the solution, but your solution is, and we adopt
> your solution for *everything* instead.
>
> If neither of those are possible, then that's really not our problem,
> and it's not _us_ who are being "intransigent".

 indeed.

 ok.  so.  we come back to the question again: what shall i propose to
them that they consider doing, and what benefit would it be to them to
do so?

 i cannot go to them and say "you have to do this [insert proposal
here]" - it has to be more subtle than that.

 l.
