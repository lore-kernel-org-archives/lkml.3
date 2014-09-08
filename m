Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaIHWvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:51:43 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47663 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755029AbaIHWvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:51:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/g61qW0WDUpNWjmP1DmjKq
Date: Mon, 8 Sep 2014 15:51:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL 2/2] ARM: OMAP4+: PRM fixes, DRA7 suspend-to-ram
 support
Message-ID: <20140908225135.GP3238@atomide.com>
References: <1410195620-6347-1-git-send-email-nm@ti.com>
 <1410195620-6347-2-git-send-email-nm@ti.com>
 <20140908223204.GN3238@atomide.com>
 <20140908224524.GA31480@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908224524.GA31480@kahuna>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140908 15:45]:
> On 15:32-20140908, Tony Lindgren wrote:
> > * Nishanth Menon <nm@ti.com> [140908 10:02]:
> > > Hi Tony,
> > > Please pull the following changes.
> > > 
> > > part 2: "ARM: OMAP3+: PRM: fix up prm_handling"
> > > http://marc.info/?l=linux-kernel&m=140871580806186&w=2
> > > Status: Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > > 
> > > part 3: "ARM: OMAP5+: pdata quirks for pinctrl"
> > > http://marc.info/?l=linux-kernel&m=140871598306262&w=2
> > > Status: Sending pull based on http://marc.info/?l=linux-kernel&m=140871666506706&w=2 (Acked by Tony, Pulled by Linus W)
> > > 
> > > part 5: "ARM: OMAP5 / DRA7: Add framework for suspend and cpuidle"
> > > http://marc.info/?l=linux-kernel&m=140871637106555&w=2
> > > Status: picked up kevin's tested and reviewed-by, dropped cpuidle for this pull
> > > 
> > > These could go into your tree for the branch  omap-for-v3.18/soc
> > > 
> > > The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:
> > > 
> > >   Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)
> > > 
> > > are available in the git repository at:
> > > 
> > >   https://github.com/nmenon/linux-2.6-playground.git pull/v3.18/for-omap-soc
> > 
> > Thanks pulling into omap-for-v3.18/soc.
> 
> Tony, Apologies, I missed the last patch in the series:
> 
> https://patchwork.kernel.org/patch/4765011/
> 
> If you could cherry-pick the same with 
> Reviewed-by: Kevin Hilman <khilman@linaro.org>
> Tested-by: Kevin Hilman <khilman@linaro.org>
> based on Kevin's feedback:
> http://marc.info/?l=linux-arm-kernel&m=140916701909122&w=2

OK no problem, will apply into omap-for-v3.18/soc.

Tony
