Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab3DVKtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:49:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:37901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3DVKtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:49:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="322217011"
Date: Mon, 22 Apr 2013 15:47:41 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 24/32 v2] dmaengine: ste_dma40: Supply full Device Tree
 parsing support
Message-ID: <20130422101741.GS24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-25-git-send-email-lee.jones@linaro.org>
 <20130418121253.GF27903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418121253.GF27903@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 01:12:53PM +0100, Lee Jones wrote:
> Using the new DMA DT bindings and API, we can register the DMA40 driver
> as Device Tree capable. Now, when a client attempts to allocate a
> channel using the DMA DT bindings via its own node, we are able to parse
> the request and allocate a channel in the correct manner.
> +
> +	switch (D40_DT_FLAGS_MODE(flags)) {
> +	case 0: cfg.mode = STEDMA40_MODE_LOGICAL; break;
> +	case 1: cfg.mode = STEDMA40_MODE_PHYSICAL; break;
ah there was a v2, i need to see the thread, this one still needs to be fixed
though

--
~Vinod
