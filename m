Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3FFNP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:15:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37460 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab3FFNPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:15:25 -0400
Date: Thu, 6 Jun 2013 14:15:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
	Uploading linux (3.9.4-1))
Message-ID: <20130606131506.GO18614@n2100.arm.linux.org.uk>
References: <51AFA6DD.3000202@wwwdotorg.org> <CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com> <1370469574.18839.33.camel@localhost> <CAPweEDxMpeJc-w=Yd7d2OT=UisRBp2rxf-MPMDUCOG3EyJz1GQ@mail.gmail.com> <CAKON4OxwyV2f_iTEb5RnP_azc7EsSxPdku_TY5WLWxN7USiY1Q@mail.gmail.com> <CAPweEDw1BabE0cmT5fxZ3Z9p9EH508M3Nzcqk2VcO0oz-qYsvg@mail.gmail.com> <1370475609.20454.44.camel@localhost> <CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com> <1370477958.20454.68.camel@localhost> <CAPweEDyPffcN9cNJ10ZHt+AZJHTRdU0LMfCGM_756uAbf+NEBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPweEDyPffcN9cNJ10ZHt+AZJHTRdU0LMfCGM_756uAbf+NEBQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 01:22:04PM +0100, luke.leighton wrote:
> On Thu, Jun 6, 2013 at 1:19 AM, Henrik Nordström
> <henrik@henriknordstrom.net> wrote:
> > tor 2013-06-06 klockan 00:54 +0100 skrev luke.leighton:
> >
> >> > Not really the case. Actually the opposite. DT have this as well, and
> >> > integrated in device probing. Allwinner need to hack every driver used
> >> > to add their gpio requests to have pinmuxing triggered.
> >>
> >>  augh.  ok.  solutions.  what are the solutions here?
> >
> > What I said before.
> 
>  idea: hook into devicetree gpio functions to allow script-fex gpio
> functions to gain access in a separate module?  that sort of thing.
> 
> > Go with DT for the kernel. There is no need for two configuration
> > mechanisms doing the same thing. Disguise it in fex form (and
> > translator) if too hard for people with a DOS editior to configure.
> 
>  what methods for doing that.  i need proposals.  4 days on the clock.

No.

If you want to set time scales, please put up money to find the work to
come up with those proposals.

Virtually no one here is a charity; the charity days of open source are
long gone.  Everyone needs money to put food in their mouths, and the
way this works is that those who pay the most get the time.  That's the
nature of a open and free market.

What's more is that you have been given some good proposals already:
converting the fex description to DT for the kernel.  Wow, that means you
can use the work which has already been done in the mainline kernel for
free!  How cool is that!
