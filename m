Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab3E3R7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:59:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:62873 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab3E3R7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:59:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,772,1363158000"; 
   d="scan'208";a="345797016"
Date: Thu, 30 May 2013 22:50:50 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 6/6] MIPS: jz4740: Remove custom DMA API
Message-ID: <20130530172050.GB3767@intel.com>
References: <1369931105-28065-1-git-send-email-lars@metafoo.de>
 <1369931105-28065-7-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369931105-28065-7-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 06:25:05PM +0200, Lars-Peter Clausen wrote:
> Now that all users of the custom jz4740 DMA API have been converted to use
> the dmaengine API instead we can remove the custom API and move all the code
> talking to the hardware to the dmaengine driver.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Acked-by: Ralf Baechle <ralf@linux-mips.org>
> ---
> No changes since v1
> ---
>  arch/mips/include/asm/mach-jz4740/dma.h |  56 ------
>  arch/mips/jz4740/Makefile               |   2 +-
>  arch/mips/jz4740/dma.c                  | 307 --------------------------------
>  drivers/dma/dma-jz4740.c                | 258 +++++++++++++++++++++++----
>  4 files changed, 222 insertions(+), 401 deletions(-)
>  delete mode 100644 arch/mips/jz4740/dma.c
only dma.c, you should remove the dma.h or relocate it to linux/


rest of the series looks fine, and once we have acks from repsective subsystem
mainatiners, we should be good to merge

--
~Vinod
