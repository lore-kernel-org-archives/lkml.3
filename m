Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934819Ab3BTJ7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:59:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:42917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933890Ab3BTJ7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:59:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="288135876"
Date: Wed, 20 Feb 2013 15:28:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <djbw@fb.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Subject: Re: [PATCH 0/4] dw_dmac: introduce generic DMA binding for DT
Message-ID: <20130220095818.GI23302@intel.com>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de>
 <20130220080348.GF23302@intel.com>
 <201302200950.26182.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302200950.26182.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 09:50:25AM +0000, Arnd Bergmann wrote:
> On Wednesday 20 February 2013, Vinod Koul wrote:
> > Since there is still churn, would it make sense if I just revert the SPEAr13xx
> > patch (your first patch) and send a pull request to Linus.
> > Since there are no users and not much testing has been done, I think we can push
> > these to 3.10 via arm-soc/slave-dma tree.
> > 
> > Gives more testing and usage will go along as well.
> > Since merge window is open, I would like my pull to go soonish and not churn the
> > tree much.
> 
> Reverting the SPEAr13xx would definitely help, yes. The reason why I'd also like
> to see the second patch get merged is so that we can do the SPEAr changes in 3.10
> without having an interdependency between the trees. I tried very hard to
> make the patch have a minimal impact on the non-DT code path to avoid regressions.
Ok, i have applied your revert patch. Will send the PULL to linus by friday.

> Maybe you can send your tree now with just the revert applied, and then send the
> other one separately next week along with any bug fixes that may have accumulated
> by then?
And then makes sense to send second PULL with fixes accumulated and the second
patch, so that 3.10 is easier for all.  think we can compact() patch is second
request as well

--
~Vinod
