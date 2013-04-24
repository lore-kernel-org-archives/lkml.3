Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab3DXIyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:54:06 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61328 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab3DXIyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:54:03 -0400
Date: Wed, 24 Apr 2013 09:53:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 05/32] dmaengine: ste_dma40: Supply macros to resolve
 'src' and 'dst' directions
Message-ID: <20130424085358.GJ17416@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-6-git-send-email-lee.jones@linaro.org>
 <20130422094250.GJ24632@intel.com>
 <20130422102748.GJ3432@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130422102748.GJ3432@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013, Lee Jones wrote:

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

Are you happy to Ack this one too if I follow up with a subsequent
patch converting all STEDMA direction defines over to the generic DMA
ones? There are also quite a lot in platform data that I'd like to
convert too.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
