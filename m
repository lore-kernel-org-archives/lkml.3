Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaKJUfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:35:40 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52445 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752732AbaKJUfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:35:36 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Odwq7dcRgDSXEsdTyVh4Z
Date: Mon, 10 Nov 2014 12:34:52 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH V2 3/3] ARM: dts: dra72-evm: Add MMC nodes
Message-ID: <20141110203451.GU31454@atomide.com>
References: <1413901848-32268-1-git-send-email-nm@ti.com>
 <1413902156-32684-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413902156-32684-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [141021 07:37]:
> Add MMC1 and 2 nodes. MMC1 is SDcard and MMC2 is eMMC.
> 
> NOTE on MMC1 card detect: Ideally, we should be using in-built SDCD
> support, but we dont have it yet. So, use the fact that control module
> of DRA7 is setup such that no matter what mode one configures it, GPIO
> option is always hardwired in - use GPIO mode for SDcard detection.
> 
> [peter.ujfalusi@ti.com]
> The power line feeding the SD card is also used by other devices on the EVM.
> Use generic name instead of mmc2_3v3 so when other devices want to use the
> same regulator it will look a bit better.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
> 
> Apologies on the spam, I got my own name screwed up -fixing that right now

Applying all three into omap-for-v3.19/dt thanks.

Tony
 
> Changes in V2: Fixes the formatting error in author name.
> V1: https://patchwork.kernel.org/patch/5125291/
