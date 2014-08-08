Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaHHRga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:36:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:5572 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaHHRg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,826,1400050800"; 
   d="scan'208";a="573812137"
Date: Fri, 8 Aug 2014 22:43:28 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH] dmaengine: sun6i: depends on RESET_CONTROLLER
Message-ID: <20140808171328.GA13288@intel.com>
References: <1407430844-30498-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407430844-30498-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 07:00:44PM +0200, Maxime Ripard wrote:
> Fixes a compilation error when RESET_CONTROLLER is not enabled in the
> configuration.
> 
> drivers/dma/sun6i-dma.c: In function 'sun6i_dma_probe':
> drivers/dma/sun6i-dma.c:911:2: error: implicit declaration of function 'devm_reset_control_get' [-Werror=implicit-function-declaration]

Applied, thanks

-- 
~Vinod
