Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3IBLQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:16:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:19964 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab3IBLQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:16:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="scan'208";a="289815911"
Date: Mon, 2 Sep 2013 16:00:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: djbw@fb.com, linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        max.filippov@cogentembedded.com
Subject: Re: [PATCH v3] dma: add driver for R-Car HPB-DMAC
Message-ID: <20130902103000.GL7376@intel.com>
References: <201308250033.24936.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308250033.24936.sergei.shtylyov@cogentembedded.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 12:33:24AM +0400, Sergei Shtylyov wrote:
> From: Max Filippov <max.filippov@cogentembedded.com>
> 
> Add support for HPB-DMAC found in Renesas R-Car SoCs, using 'shdma-base' DMA 
> driver framework.
> 
> Based on the original patch by Phil Edworthy <phil.edworthy@renesas.com>.
> 
> Signed-off-by: Max Filippov <max.filippov@cogentembedded.com>
> [Sergei: removed useless #include, sorted #include's, fixed HPB_DMA_TCR_MAX,
> fixed formats and removed line breaks in the dev_dbg() calls, rephrased and
> added IRQ # to the shdma_request_irq() failure message, added MODULE_AUTHOR(),
> removed '__init'/'__exit' annotations from the probe()/remove() methods, removed
> '__initdata' annotation from 'hpb_dmae_driver', fixed guard macro name in the
> header file, fixed #define ASYNCRSTR_ASRST20, added #define ASYNCRSTR_ASRST24,
> added the necessary runtime PM calls to the probe() and remove() methods,
> handled errors returned by dma_async_device_register(), beautified comments
> and #define's.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Applied, thanks

~Vinod
