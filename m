Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab3EWKzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:55:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:40201 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125Ab3EWKzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:55:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,727,1363158000"; 
   d="scan'208";a="341946301"
Date: Thu, 23 May 2013 15:49:19 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 0/2] dma: support Lynxpoint DMA
Message-ID: <20130523101919.GB30200@intel.com>
References: <1368003349-12204-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130514045423.GC27639@intel.com>
 <1369128579.29283.139.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369128579.29283.139.camel@smile>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 12:29:39PM +0300, Andy Shevchenko wrote:
> On Tue, 2013-05-14 at 10:24 +0530, Vinod Koul wrote: 
> > On Wed, May 08, 2013 at 11:55:47AM +0300, Andy Shevchenko wrote:
> > > This is the rest of patch series related to ACPI DMA helpers and Lynxpoint DMAC.
> > > Patches are rebased against current Linus' tree and Vinod's branch for-linus.
> > > 
> > > Since v2:
> > >  - remove patches that are already in the Vinod's tree
> > >  - rebase on top of today's origin/master and Vinod's for-linus branch
> > >  - fix description in patch 2/2
> > Applied both, Thanks
> 
> Thank you for applying them to next.
> 
> I'm just wondering if you are going to send pull request soon to get
> them in the v3.10-rcX.
Nope these are in next & would show up in Linus's tree in next merge window.
Something which is not a bug fix doesnt get merged in rc's. You should know the
process
> 
> Besides those two are really needed to support Haswell properly, there
> are people who are waiting for those patches, because patches touch ACPI
> subsystem.
well distro's should cherry-pick the patch, this is fairly common way to do so

--
~Vinod
