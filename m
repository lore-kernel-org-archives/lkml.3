Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab3ATM37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 07:29:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:2404 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3ATM36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 07:29:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,500,1355126400"; 
   d="scan'208";a="193134815"
Date: Sun, 20 Jan 2013 04:05:15 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Matt Porter <mporter@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>
Subject: Re: [RESEND][PATCH] dma: edma: fix slave config dependency on
 direction
Message-ID: <20130120120515.GB23398@intel.com>
References: <1357843264-27045-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357843264-27045-1-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 01:41:04PM -0500, Matt Porter wrote:
> The edma_slave_config() implementation depends on the
> direction field such that it will not properly configure
> a slave channel when called without direction set.
> 
> This fixes the implementation so that the slave config
> is copied as is and prep_slave_sg() handles the
> direction dependent handling. spi-omap2-mcspi and
> omap_hsmmc both expose this bug as they configure the
> slave channel config from a common path with an unconfigured
> direction field.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
Applied, Thanks

--
~Vinod
