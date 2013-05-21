Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab3EUJ3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:29:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:10155 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab3EUJ3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:29:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="317052530"
Message-ID: <1369128579.29283.139.camel@smile>
Subject: Re: [PATCH v3 0/2] dma: support Lynxpoint DMA
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Date: Tue, 21 May 2013 12:29:39 +0300
In-Reply-To: <20130514045423.GC27639@intel.com>
References: <1368003349-12204-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20130514045423.GC27639@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 10:24 +0530, Vinod Koul wrote: 
> On Wed, May 08, 2013 at 11:55:47AM +0300, Andy Shevchenko wrote:
> > This is the rest of patch series related to ACPI DMA helpers and Lynxpoint DMAC.
> > Patches are rebased against current Linus' tree and Vinod's branch for-linus.
> > 
> > Since v2:
> >  - remove patches that are already in the Vinod's tree
> >  - rebase on top of today's origin/master and Vinod's for-linus branch
> >  - fix description in patch 2/2
> Applied both, Thanks

Thank you for applying them to next.

I'm just wondering if you are going to send pull request soon to get
them in the v3.10-rcX.

Besides those two are really needed to support Haswell properly, there
are people who are waiting for those patches, because patches touch ACPI
subsystem.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
