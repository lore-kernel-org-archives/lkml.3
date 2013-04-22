Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3DVKkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:40:19 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:41925 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab3DVKkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:40:17 -0400
Date: Mon, 22 Apr 2013 11:40:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 15/32] dmaengine: ste_dma40: Separate Logical Global
 Interrupt Mask (GIM) unmasking
Message-ID: <20130422104012.GL3432@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-16-git-send-email-lee.jones@linaro.org>
 <20130422095130.GM24632@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130422095130.GM24632@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
> >  		 u32 *src_cfg, u32 *dst_cfg, bool is_log)
> > @@ -107,11 +113,6 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
> >  			src |= 1 << D40_SREG_CFG_PRI_POS;
> >  			dst |= 1 << D40_SREG_CFG_PRI_POS;
> shouldnt these be converted to BIT() macro and in gim_unmask above?
> Driver needs to be consistent in doing things

Absolutely they do. I haven't converted ste_dma40_ll.c to BIT yet
though. I have this on my TODO and it will happen in the next
patch-set.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
