Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab3HYJVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 05:21:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:47177 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab3HYJVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 05:21:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,950,1367996400"; 
   d="scan'208";a="391658434"
Date: Sun, 25 Aug 2013 14:06:46 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Andy Shevchenko'" <andriy.shevchenko@linux.jf.intel.com>,
        "'Fabio Estevam'" <fabio.estevam@freescale.com>,
        "'Shawn Guo'" <shawn.guo@linaro.org>
Subject: Re: [PATCH] dma: sh: remove unnecessary platform_set_drvdata()
Message-ID: <20130825083646.GG8091@intel.com>
References: <003001ce9e54$12595950$370c0bf0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003001ce9e54$12595950$370c0bf0$%han@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 06:51:56PM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
Can you pls rebase this as resend. I have applied bunch of sh-dma patches and
this doenst apply for me

~Vinod
