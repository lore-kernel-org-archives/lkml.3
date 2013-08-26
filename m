Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3HZJJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 05:09:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:8620 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab3HZJJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 05:09:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,956,1367996400"; 
   d="scan'208";a="393377327"
Date: Mon, 26 Aug 2013 13:54:26 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Simon Horman'" <horms@verge.net.au>,
        "'Andy Shevchenko'" <andriy.shevchenko@linux.jf.intel.com>,
        "'Fabio Estevam'" <fabio.estevam@freescale.com>,
        "'Shawn Guo'" <shawn.guo@linaro.org>
Subject: Re: [PATCH RESEND] dma: sh: remove unnecessary
 platform_set_drvdata()
Message-ID: <20130826082426.GJ2748@intel.com>
References: <001e01cea1f3$b0d5a780$1280f680$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001e01cea1f3$b0d5a780$1280f680$%han@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 09:32:05AM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
Applied, thanks

~Vinod
