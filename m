Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbbAWJof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:44:35 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55270 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbbAWJoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:44:30 -0500
Date: Fri, 23 Jan 2015 10:44:31 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mario Smarduch <m.smarduch@samsung.com>, Paul Bolle <pebolle@tiscali.nl>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: KVM: CONFIG_LOCK_DEP and CONFIG_LOCK_DETECTOR?
Message-ID: <20150123094431.GI15076@cbox>
References: <1421919245.13638.50.camel@x220>
 <54C14BCF.1050902@samsung.com>
 <54C14D01.2010506@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C14D01.2010506@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 07:18:25PM +0000, Marc Zyngier wrote:
> On 22/01/15 19:13, Mario Smarduch wrote:
> > On 01/22/2015 01:34 AM, Paul Bolle wrote:
> >> Mario,
> >>
> >> Your commit c64735554c0a ("KVM: arm: Add initial dirty page locking
> >> support") is included in today's linux-next (ie, next-20150122). I
> >> noticed because a script I use to check linux-next spotted a minor
> >> problem with it.
> >>
> >> This commit added a comment that mentions CONFIG_LOCK_DEP and
> >> CONFIG_LOCK_DETECTOR. It seems CONFIG_LOCKDEP and CONFIG_LOCKUP_DETECTOR
> >> should be used instead. Is a trivial patch to fix these typos queued
> >> somewhere?
> >>
> >> Thanks,
> >>
> >>
> >> Paul Bolle
> >>
> > 
> > Hi Paul,
> >   thanks for spotting that. No there is no trivial patch
> > queued, didn't notice it until now. Can I submit a follow
> > up trivial patch later?
> 
> Yeah, that can definitely wait. I think we have slightly bigger fish to
> fry for now... ;-)
> 
> If someone sends us a patch once -rc1 is out, we'll queue it.
> 
I'll just fix it up before sending the pull request today.

-Christoffer
