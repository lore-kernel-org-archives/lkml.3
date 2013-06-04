Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3FDNns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:43:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:26369 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab3FDNnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:43:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,799,1363158000"; 
   d="scan'208";a="344569166"
Message-ID: <1370353420.29283.287.camel@smile>
Subject: Re: [PATCH v1 0/4] dw_dmac: move to own folder and split
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, viresh.kumar@linaro.org,
        Felipe Balbi <balbi@ti.com>
Date: Tue, 04 Jun 2013 16:43:40 +0300
In-Reply-To: <4298714.mlF8oq2qNQ@wuerfel>
References: <1370349382-20914-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <4298714.mlF8oq2qNQ@wuerfel>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-04 at 15:01 +0200, Arnd Bergmann wrote: 
> On Tuesday 04 June 2013 15:36:18 Andy Shevchenko wrote:
> > This is second attempt to do split as suggested by Arnd et al [1,2].
> > There are three most important patches:
> >  2/4 moves driver to its own folder
> >  3/4 does the actual split
> >  4/4 introduces PCI part of the driver
> > 
> > During this files are renamed: mostly means that dw_dmac prefix is eliminated.
> > I hope to get it ready to be included in v3.11.
> > 
> > [1] http://www.spinics.net/lists/kernel/msg1408174.html
> > [2] http://www.spinics.net/lists/kernel/msg1408495.html
> 
> Whole series
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> provided you make it work with !CONFIG_PM.

Thank you for review.

I will wait for a while, if no more comments I will resubmit v2.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
