Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3HVFTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:19:11 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18853 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3HVFTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:19:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 21 Aug 2013 22:19:08 -0700
Date: Thu, 22 Aug 2013 13:19:05 +0800
From: Richard Zhao <rizhao@nvidia.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>, "djbw@fb.com" <djbw@fb.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH] DMA: let filter functions of of_dma_simple_xlate
 possible check of_node
Message-ID: <20130822051904.GA2685@rizhao-lap>
References: <1375408800-11789-1-git-send-email-rizhao@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1375408800-11789-1-git-send-email-rizhao@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 10:00:00AM +0800, Richard Zhao wrote:
> pass of_phandle_args dma_spec to dma_request_channel in of_dma_simple_xlate,
> so the filter function could access of_node in of_phandle_args.
> 
> It also remove restriction of #dma-cells has to be one.
> 
> Signed-off-by: Richard Zhao <rizhao@nvidia.com>
> ---
>  drivers/dma/edma.c     |  7 +++++--
>  drivers/dma/of-dma.c   | 10 ++++------
>  drivers/dma/omap-dma.c |  6 ++++--
>  3 files changed, 13 insertions(+), 10 deletions(-)
> 

Hi Vinod,

Can you please pick up this change?

Hi Stephen,

Can you please give a ack or reviewed-by etc?

Thanks
Richard
