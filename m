Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaDXQZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:25:45 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30664 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaDXQZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:25:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Wg9+UOa0cQQ8oif2hwL/3
Date: Thu, 24 Apr 2014 09:25:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 00/19] bus: omap_l3_noc: driver cleanups and support
 for DRA7/AM4372
Message-ID: <20140424162536.GD22987@atomide.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
 <53504041.7090906@ti.com>
 <5350410B.5010507@ti.com>
 <5358D16A.9000500@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5358D16A.9000500@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [140424 01:55]:
> On 04/18/2014 12:00 AM, Nishanth Menon wrote:
> > On 04/17/2014 03:57 PM, Santosh Shilimkar wrote:
> >> I looked at the series and its looks pretty good. Thanks for fixups, updates.
> >> For whole series,
> >> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >>
> > 
> > Thanks.
> > 
> >>> Patches(including Peter's) is available here:
> >>> https://github.com/nmenon/linux-2.6-playground/commits/l3noc/driver-fixes-v2
> >>>
> >> Can Tony pull this branch for 3.16 then which includes Peter's series as well ?
> > 
> > there is just an empty commit with information about peter's patches
> > that i lined up to differentiate the series.. I can drop it if Tony
> > would like me to.
> 
> Looking at the branch I see my patches underneath so they are in the branch.
> It would be great if Tony pulls this... Will be a great present to my patches
> (omap_l3 patches in the branch) for their 1 year anniversary of being out on
> the mailing list ;)

If you insist :) Maybe we should have some cake or something with it?
Seriously, I always thought that's a nice clean-up set, but never thought
I'm supposed to merge it. Will merge it as soon as I'm out of the fixes
and regressions land as that way I can easier test for any kind of
new regressions that might occur related to PM at least.

Regards,

Tony
