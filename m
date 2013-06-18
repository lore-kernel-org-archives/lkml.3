Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab3FRRdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:33:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:20801 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728Ab3FRRdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:33:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,890,1363158000"; 
   d="scan'208";a="318958772"
Date: Tue, 18 Jun 2013 10:34:07 -0700
From: Jubin Mehta <jubin.mehta@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Jon Mason <jon.mason@intel.com>
Subject: Re: [PATCH] dmatest: masking tests for channel capabilities
Message-ID: <20130618173406.GB5054@intel.com>
References: <20130613172408.GA5561@intel.com>
 <CAA9_cmf5y_z_XeX7N2Jno9uvUkrFK83RN1XrxTwVqZJnbdfEWA@mail.gmail.com>
 <CAA9_cmdr7gjrbBN8tV9LAH2JXzFiegLzLPOAHVg-9sP8p9HRqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmdr7gjrbBN8tV9LAH2JXzFiegLzLPOAHVg-9sP8p9HRqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 02:12:51PM -0700, Dan Williams wrote:
> [ apologies for the resend, gmail defaulted to html ]
> 
> On Mon, Jun 17, 2013 at 2:10 PM, Dan Williams <djbw@fb.com> wrote:
> >> +Example to perform only MEMCPY and PQ mode tests (0x01 | 0x04 = 0x05):
> >> +
> >> +        % modprobe dmatest
> >> +        % echo dma0chan0 > /sys/kernel/debug/dmatest/channel
> >> +        % echo 5  > /sys/kernel/debug/dmatest/cap_mask
> >> +        % echo 1 > /sys/kernel/debug/dmatest/iterations
> >> +        % echo 1 > /sys/kernel/debug/dmatest/run
> >
> >
> > Hmmm, I should have paid more attention when the debugfs support was
> > initially proposed for dmatest.  As it is I see duplication and
> > configuration parameters getting out of sync with their module parameter
> > equivalents versus just having all configuration go through module
> > parameters.  module_param_call() can be used for the more complex options.
> > Debugfs at this point looks like overkill for what amounts to some simple
> > configuration variables and a result line.
> >
> > --
> > Dan
> 
Would you like to have some changes regarding the configuration
process for the module parameters of the dmatest?

Any other comments with respect to the patch?
