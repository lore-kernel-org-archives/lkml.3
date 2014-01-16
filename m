Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaAPRBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:01:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:42148 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbaAPRBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:01:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,668,1384329600"; 
   d="scan'208";a="467759441"
Date: Thu, 16 Jan 2014 21:29:21 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: hongbo.zhang@freescale.com
Cc: rob@landley.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@redhat.com>,
        Richard Henderson <rth@cygnus.com>, Jakub Jelinek <jakub@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arthur Kepner <akepner@sgi.com>, sumit.semwal@linaro.org,
        Pierre Ossman <drzeus@drzeus.cx>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Subject: Re: [PATCH resend 1/2] Documentation: move all DMA documentations
 into Documentaion/dma
Message-ID: <20140116155921.GJ25466@intel.com>
References: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 06:50:04PM +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Since there are already seven DMA documentations under the top Documentation/,
> it is better to create one dedicated directory for them.

Well the problem is that not everything is same. Some of these mean how to use
dma mapping API, couple are related to dmaengine, so clubing everything into
"dma" doesnt sound right to me!

--
~Vinod
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> Cc: David S. Miller <davem@redhat.com>
> Cc: Richard Henderson <rth@cygnus.com>
> Cc: Jakub Jelinek <jakub@redhat.com>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Arthur Kepner <akepner@sgi.com>
> Cc: sumit.semwal@linaro.org
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Pierre Ossman <drzeus@drzeus.cx>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  Documentation/{ => dma}/DMA-API-HOWTO.txt   |    0
>  Documentation/{ => dma}/DMA-API.txt         |    0
>  Documentation/{ => dma}/DMA-ISA-LPC.txt     |    0
>  Documentation/{ => dma}/DMA-attributes.txt  |    0
>  Documentation/{ => dma}/dma-buf-sharing.txt |    0
>  Documentation/{ => dma}/dmaengine.txt       |    0
>  Documentation/{ => dma}/dmatest.txt         |    0
>  7 files changed, 0 insertions(+), 0 deletions(-)
>  rename Documentation/{ => dma}/DMA-API-HOWTO.txt (100%)
>  rename Documentation/{ => dma}/DMA-API.txt (100%)
>  rename Documentation/{ => dma}/DMA-ISA-LPC.txt (100%)
>  rename Documentation/{ => dma}/DMA-attributes.txt (100%)
>  rename Documentation/{ => dma}/dma-buf-sharing.txt (100%)
>  rename Documentation/{ => dma}/dmaengine.txt (100%)
>  rename Documentation/{ => dma}/dmatest.txt (100%)
> 
> diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/dma/DMA-API-HOWTO.txt
> similarity index 100%
> rename from Documentation/DMA-API-HOWTO.txt
> rename to Documentation/dma/DMA-API-HOWTO.txt
> diff --git a/Documentation/DMA-API.txt b/Documentation/dma/DMA-API.txt
> similarity index 100%
> rename from Documentation/DMA-API.txt
> rename to Documentation/dma/DMA-API.txt
> diff --git a/Documentation/DMA-ISA-LPC.txt b/Documentation/dma/DMA-ISA-LPC.txt
> similarity index 100%
> rename from Documentation/DMA-ISA-LPC.txt
> rename to Documentation/dma/DMA-ISA-LPC.txt
> diff --git a/Documentation/DMA-attributes.txt b/Documentation/dma/DMA-attributes.txt
> similarity index 100%
> rename from Documentation/DMA-attributes.txt
> rename to Documentation/dma/DMA-attributes.txt
> diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma/dma-buf-sharing.txt
> similarity index 100%
> rename from Documentation/dma-buf-sharing.txt
> rename to Documentation/dma/dma-buf-sharing.txt
> diff --git a/Documentation/dmaengine.txt b/Documentation/dma/dmaengine.txt
> similarity index 100%
> rename from Documentation/dmaengine.txt
> rename to Documentation/dma/dmaengine.txt
> diff --git a/Documentation/dmatest.txt b/Documentation/dma/dmatest.txt
> similarity index 100%
> rename from Documentation/dmatest.txt
> rename to Documentation/dma/dmatest.txt
> -- 
> 1.7.9.5
> 
> 
> 

-- 
