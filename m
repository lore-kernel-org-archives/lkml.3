Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3HYJxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 05:53:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:62927 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab3HYJwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 05:52:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,951,1367996400"; 
   d="scan'208";a="368103843"
Date: Sun, 25 Aug 2013 14:37:41 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Andy Shevchenko'" <andriy.shevchenko@linux.jf.intel.com>,
        "'Fabio Estevam'" <fabio.estevam@freescale.com>,
        "'Shawn Guo'" <shawn.guo@linaro.org>
Subject: Re: [PATCH] dma: ipu: remove unnecessary platform_set_drvdata()
Message-ID: <20130825090741.GH8091@intel.com>
References: <003101ce9e54$35dc8910$a1959b30$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003101ce9e54$35dc8910$a1959b30$%han@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 06:52:54PM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
Applied, thanks

~Vinod
