Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab3DVKvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:51:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:63295 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab3DVKvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:51:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="289702741"
Date: Mon, 22 Apr 2013 15:49:49 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 05/32] dmaengine: ste_dma40: Supply macros to resolve
 'src' and 'dst' directions
Message-ID: <20130422101949.GU24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-6-git-send-email-lee.jones@linaro.org>
 <20130422094250.GJ24632@intel.com>
 <20130422102748.GJ3432@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130422102748.GJ3432@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 11:27:48AM +0100, Lee Jones wrote:
> On Mon, 22 Apr 2013, Vinod Koul wrote:
> 
> > On Thu, Apr 18, 2013 at 11:11:47AM +0100, Lee Jones wrote:
> > > There are lots of lengthy if() statements located sporadically up and
> > > down the driver. This simple macro should make many of them a little
> > > simpler to decipher. The remainder have to stay in place, as they
> > > detail slightly more specific settings.
> > I would like these to be DMAENGINE_IS_SRC...
> 
> I don't understand, as they're DMA40 specific?
> 
> > and this patch use the defines provided in dmaengine
> 
> I think a subsequent patch doing he following would be more suitable:
> 
> s/STEDMA40_MEM_TO_MEM/DMA_MEM_TO_MEM/
> s/STEDMA40_MEM_TO_PERIPH/DMA_MEM_TO_DEV/
> s/STEDMA40_PERIPH_TO_MEM/DMA_DEV_TO_MEM/
> s/STEDMA40_PERIPH_TO_PERIPH/DMA_DEV_TO_DEV/
> 
> If you don't mind?
sounds like a good plan

--
~Vinod
