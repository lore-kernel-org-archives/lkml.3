Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab3HYIVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 04:21:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:39566 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab3HYIVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 04:21:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,950,1367996400"; 
   d="scan'208";a="386125686"
Date: Sun, 25 Aug 2013 13:06:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v5 0/7] DMA: shdma: switch DT to use OF device ID tables
Message-ID: <20130825073656.GF8091@intel.com>
References: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 04:50:35PM +0200, Guennadi Liakhovetski wrote:
> In this version of shdma Device Tree support I preserved the DT 
> configuration approach via OF device ID tables from v4, but now it is only 
> used for the DT-mode, the C-version is left untouched. In this series I 
> only include one platform: r8a73a4-based APE6EVM, if accepted, others can 
> be added easily. I also took care not to include mach/*.h headers in 
> driver .c files. To illustrate the use of DT DMA support for MMC DMA on 
> APE6EVM a patch from a previously separate patch series "DMA for MMCIF and 
> SDHI devices in DT mode"
I have applied all the dma patches, the ARM ones fail for me so should possible
go thru ARM tree.

thanks
~Vinod
