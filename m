Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934Ab3CHNIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:08:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:14054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab3CHNID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:08:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,807,1355126400"; 
   d="scan'208";a="296765563"
Message-ID: <1362748065.28241.159.camel@smile>
Subject: Re: [PATCH 05/10] dmatest: split test parameters to separate
 structure
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 08 Mar 2013 15:07:45 +0200
In-Reply-To: <CAKohpokhM-gdDMAb-f1GnoacsyXqEHqo20EkemUGrNDfw+Mw-g@mail.gmail.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1362388174-3435-6-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAKohpokhM-gdDMAb-f1GnoacsyXqEHqo20EkemUGrNDfw+Mw-g@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 17:16 +0800, Viresh Kumar wrote: 
> On 4 March 2013 17:09, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Better to keep test parameters separate from internal variables.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dmatest.c | 109 ++++++++++++++++++++++++++++----------------------
> >  1 file changed, 62 insertions(+), 47 deletions(-)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Though i don't feel a real need of keeping this in separate patches.
> We can have one for fixing these :)

Do you mean to merge patche 3,4, and 5 into one?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
