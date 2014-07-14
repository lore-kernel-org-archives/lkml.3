Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbaGNRFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:05:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:64728 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183AbaGNRFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:05:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,659,1400050800"; 
   d="scan'208";a="456807554"
Date: Mon, 14 Jul 2014 22:31:58 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>, dmaengine@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: Update documentation for inline wrappers
Message-ID: <20140714170158.GC4387@intel.com>
References: <1402924404-32211-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402924404-32211-1-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 03:13:24PM +0200, Geert Uytterhoeven wrote:
> During the last few years, several inline wrappers for DMA operations have
> been introduced:
>   - commit 16052827d98fbc13c31ebad560af4bd53e2b4dd5 ("dmaengine/dma_slave:
>     introduce inline wrappers"),
>   - commit a14acb4ac2a1486f6633c55eb7f7ded07f3ec9fc ("DMAEngine: add
>     dmaengine_prep_interleaved_dma wrapper for interleaved api"),
>   - commit 6e3ecaf0ad49de0bed829d409a164e7107c02993 ("dmaengine: add
>     wrapper functions for device control functions").
> 
> Update the documentation to use the wrappers.

Thanks for this, applied

-- 
~Vinod

