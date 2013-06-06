Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3FFNNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:13:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37455 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab3FFNMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:12:42 -0400
Date: Thu, 6 Jun 2013 14:10:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        linux-arm-kernel@lists.infradead.org, debian-kernel@lists.debian.org
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
	Uploading linux (3.9.4-1))
Message-ID: <20130606131042.GN18614@n2100.arm.linux.org.uk>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com> <1370475609.20454.44.camel@localhost> <CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com> <1733666.lHUBcfUXq9@flatron> <CAPweEDzYLDzh_-OWU61dtVhajZ40QpQgZKHFYDsh3FgF=r9_ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPweEDzYLDzh_-OWU61dtVhajZ40QpQgZKHFYDsh3FgF=r9_ag@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 01:24:57PM +0100, luke.leighton wrote:
> On Thu, Jun 6, 2013 at 1:01 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> 
> > I don't see any other solution here than moving all the Allwinner code to
> > DT (as it has been suggested in this thread several times already), as
> > this is the only hardware description method supported by ARM Linux.
> 
>  i repeat again: please state, explicitly and unequivocably that you -
> linux kernel developers - are happy that the reach of linux and
> gnu/linux OSes is dramatically reduced due to this intransigent
> position.

If companies are going to go off and invent the square wheel, and that
makes *them* suffer the loss of being able to merge back into the
mainline kernel, thereby making *their* job of moving forward with
their kernel versions much harder, then yes, we *are* happy.

Companies will always do idiotic things; it's *them* and their users
who have to live with the results of that bad decision making process.

Eventually, the pain of being outside the mainline kernel will become
too great, especially if their users demand things like kernel upgrades
from them.  Eventually, they will change.

And no, this isn't an intransigent position.  This is reality given
that ARM already has way too much code in the Linux kernel and we're
trying to reduce that through the use of technologies like DT.  The
last thing we need right now is for another "DT" like implementation
to come along which is only used on a minority of platforms - even if
the platform it is used on is successful.

The way this works is this:
- you either go with the policies which are set, or
- you change the policy as a whole because you have a technically
  superior solution

What that means in this case is either you adopt DT, or you convince
everyone that DT isn't the solution, but your solution is, and we adopt
your solution for *everything* instead.

If neither of those are possible, then that's really not our problem,
and it's not _us_ who are being "intransigent".
