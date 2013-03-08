Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044Ab3CHNMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:12:02 -0500
Received: from mga14.intel.com ([143.182.124.37]:49865 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab3CHNMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:12:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,807,1355126400"; 
   d="scan'208";a="266805463"
Message-ID: <1362748282.28241.163.camel@smile>
Subject: Re: [PATCH 00/10] dmatest: update the module to use debugfs
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 08 Mar 2013 15:11:22 +0200
In-Reply-To: <20130307062041.GE13370@intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20130307062041.GE13370@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 11:50 +0530, Vinod Koul wrote: 
> On Mon, Mar 04, 2013 at 11:09:24AM +0200, Andy Shevchenko wrote:
> > The first approach to get dmatest module more flexible and easier to play with.
> > The amount of patches could be reduced, but I would like to get a comments
> > first on smaller pieces. The entire series creates dmatest.txt file in the
> > Documentation folder. Similar description is scattered through the commit
> > messages.
> > 
> > Module was tested on Intel Medfield and Lynxpoint systems with dw_dmac DMA
> > controller embedded.
> Overall the series looks good. I think it can applied in this form as well.

Viresh, so, you are the only one who speaks about reducing amount of
patches. Do you think is better to either reduce, or leave as is? In
case of go with smaller amount, could you provide simple scheme which
patch should be merged with which?


> > 
> > Andy Shevchenko (10):
> >   dmatest: cancel thread immediately when asked for
> >   dmatest: allocate memory for pq_coefs from heap
> >   dmatest: create dmatest_info to keep test parameters
> >   dmatest: move dmatest_channels and nr_channels to dmatest_info
> >   dmatest: split test parameters to separate structure
> >   dmatest: run test via debugfs
> >   dmatest: return actual state in 'run' file
> >   dmatest: define MAX_ERROR_COUNT constant
> >   dmatest: gather test results in the linked list
> >   dmatest: append verify result to results
> > 
> >  Documentation/dmatest.txt |  81 +++++
> >  drivers/dma/dmatest.c     | 887 +++++++++++++++++++++++++++++++++++++++-------
> >  2 files changed, 832 insertions(+), 136 deletions(-)
> >  create mode 100644 Documentation/dmatest.txt

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
