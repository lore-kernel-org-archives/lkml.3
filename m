Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaATIp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:45:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:16254 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbaATIp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:45:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="461526290"
Date: Mon, 20 Jan 2014 13:13:49 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: hongbo.zhang@freescale.com
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, LeoLi@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: Freescale: change BWC from 256 bytes to 1024 bytes
Message-ID: <20140120074349.GH26823@intel.com>
References: <1389852653-8806-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389852653-8806-1-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 02:10:53PM +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Freescale DMA has a feature of BandWidth Control (ab. BWC), which is currently
> 256 bytes and should be changed to 1024 bytes for best DMA throughput.
> Changing BWC from 256 to 1024 will improve DMA performance much, in cases
> whatever one channel is running or multi channels are running simultanously,
> large or small buffers are copied.  And this change doesn't impact memory
> access performance remarkably, lmbench tests show that for some cases the
> memory performance are decreased very slightly, while the others are even
> better.
> Tested on T4240.

Applied, thanks

--
~Vinod
