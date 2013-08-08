Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058Ab3HHImb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:42:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:48985 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933886Ab3HHImV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:42:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,837,1367996400"; 
   d="scan'208";a="343426506"
Message-ID: <1375951326.403.25.camel@smile>
Subject: Re: [PATCH 1/3] dmatest: make module parameters writable
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "Blin, Jerome" <jerome.blin@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Date: Thu, 08 Aug 2013 11:42:06 +0300
In-Reply-To: <CE2134A4.1D1FD%djbw@fb.com>
References: <CE2134A4.1D1FD%djbw@fb.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 17:49 +0000, Dan Williams wrote: 
> 
> On 7/31/13 7:28 AM, "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>
> wrote:
> 
> >On Tue, 2013-07-23 at 18:36 +0300, Andy Shevchenko wrote:
> >> The debugfs interface brought a copy of the test case parameters. This
> >>makes
> >> different set of values under /sys/module/dmatest/parameters/ and
> >> /sys/kernel/debug/dmatest/. The user might be confused by the
> >>divergence of
> >> values.
> >> 
> >> The proposed solution in this patch is to make module parameters
> >>writable and
> >> remove them from the debugfs. Though we're still using debugfs to
> >>control test
> >> runner and getting results.
> >> 
> >> Documentation part is updated accordingly.
> >> 
> >> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >> Suggested-by: Dan Williams <djbw@fb.com>
> >
> >Dan, do you have any comments against this series?
> >I'd like to have this incorporated into v3.12.
> 
> I like this direction, and these can go in as is.  

So, could it be considered as your ACK?
If so, I think it would be better to push it early to be in time for
v3.12

> But I think with a bit
> more work we can eventually trim the Œresults' file and the
> thread_{add|get}_result infrastructure.  Ideally we could move all result
> reporting to ftrace and let a module parameter control which errors are
> reported.
> 
> However, unless I missed it, I don¹t see this support[1] upstream yet.
> 
> 
> --
> Dan
> 
> [1]: https://lwn.net/Articles/432186/
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
