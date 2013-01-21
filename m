Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab3AUFPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 00:15:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:12079 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723Ab3AUFPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 00:15:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,504,1355126400"; 
   d="scan'208";a="276219951"
Date: Sun, 20 Jan 2013 20:50:30 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH v2] dw_dmac: allocate dma descriptors from DMA_COHERENT
 memory
Message-ID: <20130121045030.GC21551@intel.com>
References: <1358344131-18097-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358344131-18097-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 03:48:50PM +0200, Andy Shevchenko wrote:
> Currently descriptors are allocated from normal cacheable memory and that slows
> down filling the descriptors, as we need to call cache_coherency routines
> afterwards. It would be better to allocate memory for these descriptors from
> DMA_COHERENT memory. This would make code much cleaner too.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Applied Thanks

--
~Vinod
