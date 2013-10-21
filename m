Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3JUITx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:19:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:48396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab3JUITv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="377578166"
Date: Mon, 21 Oct 2013 12:56:12 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Matt Porter <matt@ohporter.com>, Mark Brown <broonie@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jyri Sarha <jsarha@ti.com>, Lars Peter-Clausen <lars@metafoo.de>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/3] dma: edma: Split out PaRAM set calculations into
 its own function
Message-ID: <20131021072612.GN14013@intel.com>
References: <1379977515-3794-1-git-send-email-joelf@ti.com>
 <1379977515-3794-2-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379977515-3794-2-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 06:05:13PM -0500, Joel Fernandes wrote:
> PaRAM set calculation is abstracted into its own function to
> enable better reuse for other DMA cases such as cyclic. We adapt
> the Slave SG case to use the new function.
> 
> This provides a much cleaner abstraction to the internals of the
> PaRAM set. However, any PaRAM attributes that are not common to
> all DMA types must be set separately such as setting of interrupts.
> This function takes care of the most-common attributes.
> 
> Also added comments clarifying A-sync case calculations.
Applied, thanks

--
~Vinod
