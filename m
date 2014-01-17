Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaAQPcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:32:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:61459 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaAQPcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:32:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,674,1384329600"; 
   d="scan'208";a="466716538"
Message-ID: <1389972737.7619.14.camel@smile>
Subject: Re: [PATCH] Add Xilinx AXI Video DMA Engine driver
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Date: Fri, 17 Jan 2014 17:32:17 +0200
In-Reply-To: <1389894803-4147-1-git-send-email-sthokal@xilinx.com>
References: <1389894803-4147-1-git-send-email-sthokal@xilinx.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 23:23 +0530, Srikanth Thokala wrote:
> Hi,
> 
> This is the driver for Xilinx AXI Video Direct Memory Access Engine.
> It is a soft IP core, which provides high-bandwidth direct memory
> access between memory and AXI4-Stream video type target peripherals 
> including peripherals which support AXI4-Stream Video Protocol. The
> core provides efficient two dimensional DMA operations with independent
> asynchronous read and write channel operation.
> 
> For more information on the IP, please refer to
> http://www.xilinx.com/support/documentation/ip_documentation/axi_vdma/v6_1/pg020_axi_vdma.pdf
> 
> This patch also provides a test client, which assumes read and write channels
> of the core are configured in a back-to-back connection.  It transfers 
> data on the write channel, read and verify the data on the read channel. 
> 
>  drivers/dma/xilinx/xilinx_vdma_test.c              |  629 ++++++++

What about to modify dmatest.c accordingly to your needs?
I see no much sense to have another copy of that in the tree.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

