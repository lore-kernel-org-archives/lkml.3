Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab3FFODh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:03:37 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55469 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab3FFODg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:03:36 -0400
Date: Thu, 6 Jun 2013 10:02:50 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        debian-kernel@lists.debian.org
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
Message-ID: <20130606140250.GA4839@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"luke.leighton" <luke.leighton@gmail.com>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>,
	devicetree-discuss <devicetree-discuss@ozlabs.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	debian-arm@lists.debian.org,
	"jonsmirl@gmail.com" <jonsmirl@gmail.com>,
	debian-kernel@lists.debian.org
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
 <1370475609.20454.44.camel@localhost>
 <CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
 <1733666.lHUBcfUXq9@flatron>
 <CAPweEDzYLDzh_-OWU61dtVhajZ40QpQgZKHFYDsh3FgF=r9_ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPweEDzYLDzh_-OWU61dtVhajZ40QpQgZKHFYDsh3FgF=r9_ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
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

But that's not a true statement.  You've said that Allwinner is
perfectly happy to carry code out of tree, by constantly porting their
hacks from mainline kernels.

For some of their customers, this will be acceptable to them.  In
those cases, Linux will still be in use.  Great!  So claiming that the
reach of Linux will be "dramatically reduced" just is not a
supportable position.

For other (potential) customers, for whom mainline kernel support is
critically important, they will choose other hardware solutions that
are in the mainline kernel.

I don't see the problem here.

						- Ted
