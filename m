Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935104Ab3DHRJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:09:19 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61771 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760109Ab3DHRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:09:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18HPAIOGsC+OudfIPvUg+RD
Date: Mon, 8 Apr 2013 10:09:14 -0700
From: Tony Lindgren <tony@atomide.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/21] ARM: OMAP2+: Adapt to ehci-omap changes for
 3.10
Message-ID: <20130408170914.GO10155@atomide.com>
References: <1363794300-31526-1-git-send-email-rogerq@ti.com>
 <515E8B99.8080803@ti.com>
 <515E9FB1.2040803@ti.com>
 <20130405154259.GZ10155@atomide.com>
 <5162B2D3.6070007@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5162B2D3.6070007@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benoit Cousson <b-cousson@ti.com> [130408 05:11]:
> Hi Tony,
> 
> On 04/05/2013 05:43 PM, Tony Lindgren wrote:
> > * Benoit Cousson <b-cousson@ti.com> [130405 03:00]:
> >> On 04/05/2013 10:30 AM, Benoit Cousson wrote:
> >>
> >> ...
> >>
> >>>>   ARM: dts: OMAP4: Add HS USB Host IP nodes
> >>>>   ARM: dts: OMAP3: Add HS USB Host IP nodes
> >>>>   ARM: dts: omap3-beagle: Add USB Host support
> >>>
> >>> These 3 DTS patches are good to me, but I cannot applied them on top of
> >>> the already existing patches I queued for 3.10.
> >>>
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git
> >>> for_3.10/dts
> >>>
> >>> Could you rebase these 3 ones only, and I will applied them.
> >>
> >> Mmm, in fact, I've just seen the pull request from Tony :-(
> >>
> >>
> >> Tony,
> >>
> >> Don't you want to remove these DTS patches from the pull-request?
> > 
> > Oops sorry :( Looks like I applied them mistakenly as I saved all
> > the patches into a mbox, then applied it. Anyways, too late to start
> > messing with it now.
> >  
> >> Otherwise, I will have to rebase the whole DTS series on top of yours.
> >> That being said, if the branch is not supposed to be rebased, it is doable.
> > 
> > I pulled in your for_3.10/dts for testing, and to me it looks like
> > it's just overlapping additions. So that should be OK to resolve while
> > pulling it in.
> > 
> > It seems there's no need to add omap-for-v3.10/usb as a dependency for
> > your for_3.10/dts unless the conflict gets non-trivial with some
> > additional patches.
> 
> The branch was not complete, with the latest additions, we do have
> conflict due to the addition of several new nodes at the same place.

OK
 
> The resolution is not that hard since it is addition of node only, but
> the rebase on to of omap-for-v3.10/usb will avoid the issue.
> 
> I have a new pre-merged branch available. for_3.10/dts_merged is based
> on omap-for-v3.10/usb and Paul's omap-devel-b-for-3.10 branch to get the
> AM33xx hwmod.
> Paul's branch is just needed to avoid AM33xx regression introduced by
> Santosh hwmod changes present in my branch.
> 
> Just let me know which one you will prefer to pull.

If the merge conflicts are non-trivial, then let's do the pre-merged
branch. That will be easier to test also in this case for am33xx.

Regards,

Tony
