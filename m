Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaEZTMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:12:50 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:56490 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751308AbaEZTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:12:49 -0400
Date: Mon, 26 May 2014 21:12:46 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 0/2] imx2-wdt: Add regmap-mmio support
Message-ID: <20140526191246.GA21870@spo001.leaseweb.com>
References: <1396575205-24394-1-git-send-email-Li.Xiubo@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396575205-24394-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xiubo,

> This patches are preparing for Vybird, LS1 and LS2. And on LS1 the IP will
> in BE mode.
> 
> Changes in V5:
> - Select the REGMAP_MMIO default for IMX2 Watchdog.
> 
> Changes in V4:
> - Add the explanation why uing the regmap APIs.
> 
> Changes in V3:
> - convert to use regmap-mmio API.
> 
> Changes in V2:
> - Add the detail information in the commit comment.
> - 'big-endians' --> 'big-endian'.
> 
> 
> 
> 
> 
> Xiubo Li (2):
>   watchdog: imx2_wdt: Sort the header files alphabetically
>   watchdog: imx2_wdt: convert to use regmap API.
> 
>  drivers/watchdog/Kconfig    |  1 +
>  drivers/watchdog/imx2_wdt.c | 62 +++++++++++++++++++++++++++------------------
>  2 files changed, 39 insertions(+), 24 deletions(-)

both patches have been added to linux-watchdog-next.

Kind regards,
Wim.

