Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3GOKMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:12:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:61279 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab3GOKMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:12:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,668,1367996400"; 
   d="scan'208";a="370403023"
Date: Mon, 15 Jul 2013 15:03:43 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Yang <leoli@freescale.com>,
        Zhang Wei <zw@melbourneit.hotkeysparking.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 00/12] dma: various minor clean ups for slave drivers
Message-ID: <20130715093343.GN16653@intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130530174727.GE3767@intel.com>
 <CAA9_cmdNiLfJjv-8Mh-Xb1ifZb4aw_9NGCVW6aWsfq6BN-DYyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmdNiLfJjv-8Mh-Xb1ifZb4aw_9NGCVW6aWsfq6BN-DYyQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 05:09:51PM -0700, Dan Williams wrote:
> On Thu, May 30, 2013 at 10:47 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Mon, May 27, 2013 at 03:14:30PM +0300, Andy Shevchenko wrote:
> >> Here is a set of small independent patches that clean up or fix minor things
> >> across DMA slave drivers.
> > The series looks fine. I am going to wait a day more and apply, pls speak up if
> > you disagree and ack if you agree
> 
> Looks ok to me.  Reminds we can probably take this one step further
> and provide a generic implementation for the common case.  It's just a
> bit inconsistent though that some engines will poll the completion
> handler (try to advance the state of the last completed cookie)
> whereas others just assume things will be completed asynchronously.
agree with that. These are the inconsistencies some of which are based on
hardware and some are user iterpretations...

--
~Vinod
