Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaEWNmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:42:13 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16766 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146AbaEWNmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:42:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19shl1i8Tb309RgXExgjzrMW0u8k+MV4nQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan 562DC57E1D0
Date: Fri, 23 May 2014 09:41:52 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Olof Johansson <olof@lixom.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Chris Ball <chris@printf.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] mmc: dove: fix missing MACH_DOVE dependency
Message-ID: <20140523134152.GA8664@titan.lakedaemon.net>
References: <1400522571-10799-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <CAPDyKFo8CdyDbJEP0GkFTHdzpkyRBZEp-jAyrU4y8qi__zChkA@mail.gmail.com>
 <CAOesGMjyk=n7MyVisfjYze9UuEb7XNv5O+c1Tndc+q1Q=PEetQ@mail.gmail.com>
 <CAPDyKFp7Sf0sdReOyC8V_-F6ozB6Vh8CEbc+R7eoe6H4t-OmYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFp7Sf0sdReOyC8V_-F6ozB6Vh8CEbc+R7eoe6H4t-OmYA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 09:40:55AM +0200, Ulf Hansson wrote:
> On 23 May 2014 09:16, Olof Johansson <olof@lixom.net> wrote:
> > On Thu, May 22, 2014 at 2:09 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >> On 19 May 2014 20:02, Sebastian Hesselbarth
> >> <sebastian.hesselbarth@gmail.com> wrote:
> >>> DT-enabled Dove moved over from ARCH_DOVE in mach-dove to MACH_DOVE in
> >>> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
> >>> DT-only MACH_DOVE Kconfig. This slipped through the cracks and now is
> >>> a fix to allow to build Dove's SDHCI driver for mach-mvebu on v3.15-rc.
> >>>
> >>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> >>> Acked-by: Jason Cooper <jason@lakedaemon.net>
> >>
> >> Thanks! Picked up for the PR I send to Chris.
> >
> > Ulf, you might consider adding your tree to linux-next if this is
> > going to be a common work flow for you guys.
> 
> That's done already. :-) There are patches which makes this visible in
> the MAINTAINERS as well, queued for 3.16.
> 
> git://git.linaro.org/people/ulf.hansson/mmc.git next
> 
> Though due to merge conflicts, during this release cycle, I didn't
> want to queue any patches besides for the mmci host driver.
> 
> >
> > It's partially up to Chris though, if he's OK with patches going into
> > your branch more or less being guaranteed to make it into his as well.
> >
> 
> Yes, we need to figure out a good work flow when using two separate
> trees. Thanks for bringing this up!

If you have any questions, please ask.  mvebu has been doing this for
several release cycles now, and I'm also doing it for irqchip now.

The biggest rule is that once you sign a tag and send a pull-request for
it, the branch is immutable up to and including that tag.

thx,

Jason.
