Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab3EWLVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:21:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:57428 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757985Ab3EWLVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:21:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,728,1363158000"; 
   d="scan'208";a="342232968"
Date: Thu, 23 May 2013 14:25:05 +0300
From: Mika Westerberg <mika.westerberg@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 0/2] dma: support Lynxpoint DMA
Message-ID: <20130523112504.GF11878@intel.com>
References: <1368003349-12204-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130514045423.GC27639@intel.com>
 <1369128579.29283.139.camel@smile>
 <20130523101919.GB30200@intel.com>
 <CAHp75Vctb1kR8gUQk0vu8scsgjBtZUq9DS0NQ+zVOPAobG0QOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vctb1kR8gUQk0vu8scsgjBtZUq9DS0NQ+zVOPAobG0QOw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 02:07:54PM +0300, Andy Shevchenko wrote:
> On Thu, May 23, 2013 at 1:19 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Tue, May 21, 2013 at 12:29:39PM +0300, Andy Shevchenko wrote:
> >> On Tue, 2013-05-14 at 10:24 +0530, Vinod Koul wrote:
> >> > On Wed, May 08, 2013 at 11:55:47AM +0300, Andy Shevchenko wrote:
> >> > > This is the rest of patch series related to ACPI DMA helpers and Lynxpoint DMAC.
> >> > > Patches are rebased against current Linus' tree and Vinod's branch for-linus.
> >> > >
> >> > > Since v2:
> >> > >  - remove patches that are already in the Vinod's tree
> >> > >  - rebase on top of today's origin/master and Vinod's for-linus branch
> >> > >  - fix description in patch 2/2
> >> > Applied both, Thanks
> >>
> >> Thank you for applying them to next.
> >>
> >> I'm just wondering if you are going to send pull request soon to get
> >> them in the v3.10-rcX.
> > Nope these are in next & would show up in Linus's tree in next merge window.
> > Something which is not a bug fix doesnt get merged in rc's. You should know the
> > process
> 
> Hmm... Now we have a situation when v3.9.x has support of Lynxpoint
> DMA, v3.10-rc2 has it broken.
> As far as I remember our discussion [1]  we agreed to wait for
> v3.10-rc1 due to merge of linux-pm patches.

Yes, and we need that stuff for BayTrail support as well. Currently Rafael
is waiting these patches so that he can then merge [1].

[1] https://lkml.org/lkml/2013/5/13/542
