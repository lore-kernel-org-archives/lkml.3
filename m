Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaIHIFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:05:10 -0400
Received: from plane.gmane.org ([80.91.229.3]:39907 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaIHIFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:05:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nicolas FERRE <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 0/4] pinctrl: at91: Fixes in probe function
Date: Mon, 8 Sep 2014 08:02:37 +0000 (UTC)
Message-ID: <loom.20140908T095726-407@post.gmane.org>
References: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.80.104.164 (Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:26.0) Gecko/20100101 Firefox/26.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pramod Gurav <pramod.gurav <at> smartplayin.com> writes:

> 
> This patchset modifies the probe function to do some changes such as 
> switching to manage version of clk_get, fixing the error path by releasing
> resources etc. The last patch adds a remove function for clean unload.
> 
> Pramod Gurav (4):
>   pinctrl: at91: Switch to using managed clk_get
>   pinctrl: at91: Fix failure path in at91_gpio_probe path
>   pinctrl: at91: Fix error handling while doing gpiochio_irqchip_add
>   pinctrl: at91: Add remove function in platform_driver
>     at91_gpio_driver
> 
>  drivers/pinctrl/pinctrl-at91.c |   51
+++++++++++++++++++++++++++++-----------
>  1 files changed, 37 insertions(+), 14 deletions(-)

Hi,

Thanks a lot for your enhancement of the at91 pinctrl driver. In the future,
can you send your patch series to the Linux ARM kernel mailing-list as well
(linux-arm-kernel@lists.infradead.org). In fact it is where all the work
around AT91 platforms is being done: you may have more chances to get your
patch accepted by sending your work there.

Anyway, it seems that Linus got your emails and they look pretty good at a
first glance.

Best regards,
-- 
Nicolas Ferre




