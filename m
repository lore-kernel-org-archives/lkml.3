Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbbAMSeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:34:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:38926 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbbAMSeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:34:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="650546166"
Date: Wed, 14 Jan 2015 00:01:44 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Paul Walmsley <pwalmsley@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: tegra: add slave capabilities reporting
Message-ID: <20150113183144.GJ15411@intel.com>
References: <alpine.DEB.2.02.1501060640220.28771@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1501060640220.28771@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 06:44:56AM +0000, Paul Walmsley wrote:
> 
> After commit ecc19d17868be9c9f8f00ed928791533c420f3e0 ("dmaengine: Add
> a warning for drivers not using the generic slave caps retrieval"),
> the Tegra APB DMA driver causes this warning during boot:
> 
> WARNING: CPU: 0 PID: 1 at drivers/dma/dmaengine.c:830 dma_async_device_register+0x294/0x538()
> this driver doesn't support generic slave capabilities reporting
> 
> Fix by setting the appropriate reporting structure fields that are
> passed to dma_async_device_register().
> 
Applied, thanks

-- 
~Vinod

