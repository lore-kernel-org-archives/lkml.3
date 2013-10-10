Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3JJRc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:32:28 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:46656 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755363Ab3JJRc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:32:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ehbifiVE3HlaadxDIbdu1
Date: Thu, 10 Oct 2013 10:32:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "=?utf-8?Q?'Beno=C3=AEt?= Cousson'" <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        "'Pali =?utf-8?Q?Roh=C3=A1r'?=" <pali.rohar@gmail.com>,
        =?utf-8?B?J9CY0LLQsNC50LvQviDQlNC40LzQuNGC0YDQvtCyJw==?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Subject: Re: [RFCv3 0/7] OMAP SSI driver
Message-ID: <20131010173211.GH29913@atomide.com>
References: <1381091235-18293-1-git-send-email-sre@debian.org>
 <20131008172815.GA8313@atomide.com>
 <20131010172128.GF28657@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131010172128.GF28657@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [131010 10:30]:
> Hi,
> 
> On Tue, Oct 08, 2013 at 10:28:15AM -0700, Tony Lindgren wrote:
> > * Sebastian Reichel <sre@debian.org> [131006 13:36]:
> > > Here is the third round of the OMAP SSI driver patches.
> > 
> > Thanks for updating these, they look good to me now:
> > 
> > Acked-by: Tony Lindgren <tony@atomide.com>
> 
> Ok. I guess it's time to check how this gets included in the kernel.
> 
> The first patch has already been queued and the last patch could
> probably go through Benoît once the DT people have reviewed the
> updated patches. The other ones would normally go through the
> hsi tree, but that one was maintained by Carlos Chinea and is 
> now more or less orphaned.

Yes, I suggest you post the .dts changes completely seprately
so driver maintainers don't accidentally pick those up.
 
> My suggestion is:
> 
> 1. I create another patch, which adds entries for hsi subsystem and
>    ssi driver to MAINTAINERS.
> 
>    It would be nice to have some co-maintainers for the subsystem.
>    Linus Walleij maybe? I think you created the launchpad blueprint [1]?
>    Especially because I have no documentation/specification for HSI, which
>    brings me to my next slightly off topic request.
> 
>    I would like to have access to SSI documentation and HSI specification.
>    Can the guys from Texas Instruments please give me some pointers how I
>    can get access to the NDA'd documentation? I couldn't find any hints
>    on ti.com.
> 
> 2. I create a patch adding Carlos Chinea to CREDITS
> 
> 3. I create a git repository and put all of the patches in there, so
>    that they can be pulled into linux-next.
> 
> 4. I add a gpg/pgp signed tag with the key used to signed this mail.
> 
> Any issues with this or any other suggestions how to proceed? And if following this
> - should I request an account on kernel.org to host the repository there,
> or should I just upload it at a random place?

That all sounds good to me. It is a *good thing* to have a maintainer
for a driver subsystem, and if you're willing to pick it up, that's
the way to go.

Regards,

Tony
 
> [0] https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Next/Trees
> [1] https://blueprints.launchpad.net/linux-linaro/+spec/hsi-subsystem-maint
> 
> -- Sebastian


