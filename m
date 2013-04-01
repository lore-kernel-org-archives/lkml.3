Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab3DASXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:23:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:31309 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990Ab3DASXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:23:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,387,1363158000"; 
   d="scan'208";a="311924467"
Date: Mon, 1 Apr 2013 23:25:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH v2 0/4] dw_dmac: cleanup for DT usage
Message-ID: <20130401175535.GF10326@intel.com>
References: <1364309637-25860-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364309637-25860-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 04:53:53PM +0200, Andy Shevchenko wrote:
> It includes few cleanups when used with DT. Patch 4/4 is a modified version of
> the [1].
Applied 1, 2, 4 & 2.2

Thanks
~Vinod
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg225366.html
> 
> Since v1:
>  - address Arnd's comments
>  - apply Acks I got from Viresh
> 
> Andy Shevchenko (3):
>   dw_dmac: fix style of the comments
>   dw_dmac: rename DT related methods to reflect their belonging
>   dw_dmac: make wrapper on of_dma_controller_register()
> 
> Arnd Bergmann (1):
>   dmaengine: dw_dmac: simplify master selection
> 
>  drivers/dma/dw_dmac.c      | 145 +++++++++++++++++++++------------------------
>  drivers/dma/dw_dmac_regs.h |   5 +-
>  2 files changed, 71 insertions(+), 79 deletions(-)
> 
> -- 
> 1.8.2.rc0.22.gb3600c3
> 
