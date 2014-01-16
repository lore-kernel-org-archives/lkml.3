Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaAPO3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:29:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:49095 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbaAPO3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:29:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,668,1384329600"; 
   d="scan'208";a="459871729"
Message-ID: <1389882551.1871.358.camel@smile>
Subject: Re: [PATCH resend 1/2] Documentation: move all DMA documentations
 into Documentaion/dma
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: hongbo.zhang@freescale.com
Cc: rob@landley.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@redhat.com>,
        Richard Henderson <rth@cygnus.com>, Jakub Jelinek <jakub@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arthur Kepner <akepner@sgi.com>, sumit.semwal@linaro.org,
        Vinod Koul <vinod.koul@intel.com>, Pierre Ossman <drzeus@drzeus.cx>
Date: Thu, 16 Jan 2014 16:29:11 +0200
In-Reply-To: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com>
References: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 18:50 +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Since there are already seven DMA documentations under the top Documentation/,
> it is better to create one dedicated directory for them.

In case DMA maintainers are okay with that I give my

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

for the dmatest.txt part.

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

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

