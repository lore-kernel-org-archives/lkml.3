Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3JUIUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:20:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:26418 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab3JUIUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:20:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="377578277"
Date: Mon, 21 Oct 2013 12:56:45 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Matt Porter <matt@ohporter.com>, Mark Brown <broonie@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jyri Sarha <jsarha@ti.com>, Lars Peter-Clausen <lars@metafoo.de>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/3] dma: edma: Increase maximum SG limit to 20
Message-ID: <20131021072645.GO14013@intel.com>
References: <1379977515-3794-1-git-send-email-joelf@ti.com>
 <1379977515-3794-4-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379977515-3794-4-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 06:05:15PM -0500, Joel Fernandes wrote:
> davinci-pcm uses 16 as the no.of periods. With this, in EDMA we have to
> allocate atleast 17 slots: 1 slot for channel, and 16 slots the periods.
> 
> Due to this, the MAX_NR_SG limitation causes problems, set it to 20 to make
> cyclic DMA work when davinci-pcm is converted to use DMA Engine. Also add
> a comment clarifying this.

Applied, thanks

--
~Vinod
