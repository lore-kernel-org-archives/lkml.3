Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3JGP1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:27:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:6061 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab3JGP1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:27:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1050,1371106800"; 
   d="scan'208";a="415224211"
Date: Mon, 7 Oct 2013 20:03:51 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: kgene.kim@samsung.com, Dan Williams <djbw@fb.com>,
        linus.walleij@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v5 2/4] dmaengine: add driver for Samsung s3c24xx SoCs
Message-ID: <20131007143351.GK2954@intel.com>
References: <201309182118.28391.heiko@sntech.de>
 <201309182119.54560.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309182119.54560.heiko@sntech.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 09:19:54PM +0200, Heiko Stübner wrote:
> This adds a new driver to support the s3c24xx dma using the dmaengine
> and makes the old one in mach-s3c24xx obsolete in the long run.
> 
> Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
> with numerous virtual channels being mapped to a lot less physical ones.
> The driver therefore borrows a lot from the amba-pl08x driver in this
> regard. Functionality-wise the driver gains a memcpy ability in addition
> to the slave_sg one.
> 
> The driver supports both the method for requesting the peripheral used
> by SoCs before the S3C2443 and the different method for S3C2443 and later.
> 
> On earlier SoCs the hardware channels usable for specific peripherals is
> constrainted while on later SoCs all channels can be used for any peripheral.
> 
> Tested on a s3c2416-based board, memcpy using the dmatest module and
> slave_sg partially using the spi-s3c64xx driver.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
