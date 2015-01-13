Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbbAMOoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:44:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:16728 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbbAMOoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:44:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="650437076"
Date: Tue, 13 Jan 2015 20:12:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kernel-build-reports@lists.linaro.org, Mark Brown <broonie@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dmaengine: k3: fix duplicate function definition
Message-ID: <20150113144257.GA3085@intel.com>
References: <E1YAwSG-0000zm-Cs@debutante>
 <20150113120751.GQ4160@sirena.org.uk>
 <1869934.MKKaD1UAQn@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1869934.MKKaD1UAQn@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 02:23:13PM +0100, Arnd Bergmann wrote:
> Commit db08425ebd51f ("dmaengine: k3: Split device_control") introduced
> two new helper functions, which unfortunately have the same names
> as the existing suspend/resume functions, resulting in a build error
> when CONFIG_PM_SLEEP is enabled:
> 
> drivers/dma/k3dma.c:823:12: error: conflicting types for 'k3_dma_resume'
>  static int k3_dma_resume(struct device *dev)
>             ^
> drivers/dma/k3dma.c:625:12: note: previous definition of 'k3_dma_resume' was here
>  static int k3_dma_resume(struct dma_chan *chan)
Applied, Thanks

-- 
~Vinod

