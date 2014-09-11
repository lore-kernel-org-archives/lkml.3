Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaIKRKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:10:04 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34636 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751215AbaIKRKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:10:02 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+VDXBlJj3X1OElWNcOteMO
Date: Thu, 11 Sep 2014 10:09:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Suman Anna <s-anna@ti.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        Markus Mayer <markus.mayer@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 0/5] OMAP Mailbox framework adoption & DT support
Message-ID: <20140911170955.GA18849@atomide.com>
References: <1406680479-18446-1-git-send-email-s-anna@ti.com>
 <20140908232053.GS3238@atomide.com>
 <20140909025225.GI10785@atomide.com>
 <540F279A.1080700@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540F279A.1080700@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suman Anna <s-anna@ti.com> [140909 09:16]:
> Hi Tony,
> 
> On 09/08/2014 09:52 PM, Tony Lindgren wrote:
> > * Tony Lindgren <tony@atomide.com> [140908 16:21]:
> >> * Suman Anna <s-anna@ti.com> [140729 17:37]:
> >>> Hi,
> >>>
> >>> This is an updated version of the OMAP Mailbox framework adoption &
> >>> DT support series, refreshed to work with the v9 version of the mailbox
> >>> framework [1] from Jassi Brar while also addressing some minor review
> >>> comments. Detailed changes are summarized below. Patches are based on
> >>> 3.16-rc2.
> >>
> >> Sorry for the delay, just noticed that I'm supposed to queue
> >> these too. I'll queue these into omap-for-v3.18/mailbox against
> >> v3.17-rc1 and will probably also merge it into omap-for-v3.18/dt
> >> as well.
> > 
> > Actually this is not compiling and seems to probably miss
> > the dependencies from Jassi, so dropping the branch.
> 
> The last 2 patches which is the framework adoption portion needs the
> framework patches from Jassi (as stated in the cover letter). I will
> ping on the framework thread to see if it is making it into 3.18. In any
> case, we should be able to take the first three patches (2 in drivers
> and 1 for DT) - they are independent of the framework and also are
> dependencies for the framework adoption patches.
> 
> > Anyways, since it seems you need to repost this again, please
> > repost the DT changes separately from the driver changes.
> 
> Yeah, the other two dependent series are merged for 3.17, so these are
> the only patches remaining. I just need to repost them on a 3.17-rc, but
> there are no changes required (even with v10 of the framework). So given
> above, do you want me to split the first 3 (there is one DT patch) and
> post them so that they can be merged for 3.18?

Yes please and looks like you already did thanks :)

Tony
