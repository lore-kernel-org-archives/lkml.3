Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3DVKSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:18:39 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:53271 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3DVKSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:18:38 -0400
Date: Mon, 22 Apr 2013 11:18:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 17/32] dmaengine: ste_dma40: Remove redundant argument
 from d40_phy_cfg()
Message-ID: <20130422101833.GI3432@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-18-git-send-email-lee.jones@linaro.org>
 <20130422093423.GD24632@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130422093423.GD24632@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if ((cfg->dir ==  STEDMA40_PERIPH_TO_MEM) ||
> > +	    (cfg->dir == STEDMA40_PERIPH_TO_PERIPH)) {
> Why would you need your own direction defines, I see that there is not much
> diff between these and what dmaengine defines, so perhpas you could use
> those?

I agree. I'll speak to the STE folk.

For this (and other) patch(es), I'll continue to use the STEDMA40 ones
though. Converting everything over to the generic defines should be a
subsequent patch-set IMHO.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
