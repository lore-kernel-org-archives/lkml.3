Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3CGGpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:45:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:14630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab3CGGpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:45:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,800,1355126400"; 
   d="scan'208";a="210248276"
Date: Thu, 7 Mar 2013 11:50:41 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/10] dmatest: update the module to use debugfs
Message-ID: <20130307062041.GE13370@intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 11:09:24AM +0200, Andy Shevchenko wrote:
> The first approach to get dmatest module more flexible and easier to play with.
> The amount of patches could be reduced, but I would like to get a comments
> first on smaller pieces. The entire series creates dmatest.txt file in the
> Documentation folder. Similar description is scattered through the commit
> messages.
> 
> Module was tested on Intel Medfield and Lynxpoint systems with dw_dmac DMA
> controller embedded.
Overall the series looks good. I think it can applied in this form as well.

> 
> Andy Shevchenko (10):
>   dmatest: cancel thread immediately when asked for
>   dmatest: allocate memory for pq_coefs from heap
>   dmatest: create dmatest_info to keep test parameters
>   dmatest: move dmatest_channels and nr_channels to dmatest_info
>   dmatest: split test parameters to separate structure
>   dmatest: run test via debugfs
>   dmatest: return actual state in 'run' file
>   dmatest: define MAX_ERROR_COUNT constant
>   dmatest: gather test results in the linked list
>   dmatest: append verify result to results
> 
>  Documentation/dmatest.txt |  81 +++++
>  drivers/dma/dmatest.c     | 887 +++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 832 insertions(+), 136 deletions(-)
>  create mode 100644 Documentation/dmatest.txt
> 
> -- 
> 1.8.2.rc0.22.gb3600c3
> 
