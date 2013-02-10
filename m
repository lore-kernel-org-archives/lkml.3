Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab3BJCmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 21:42:19 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58147 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760950Ab3BJCmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 21:42:17 -0500
Date: Sat, 9 Feb 2013 18:42:19 -0800
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        arm@kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 11/14] ARM: ux500: remove irq_base property from
 platform_data
Message-ID: <20130210024141.GE25302@quad.lixom.net>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
 <1360093715-6348-12-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360093715-6348-12-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 08:48:32PM +0100, Linus Walleij wrote:
> From: Lee Jones <lee.jones@linaro.org>
> 
> AB8500 GPIO no longer handles its GPIO IRQs. Instead, the AB8500
> core driver has taken back the responsibility. Prior to this
> happening, the AB8500 GPIO driver provided a set of virtual IRQs
> which were used as a pass-through. These virtual IRQs had a base
> of MOP500_AB8500_VIR_GPIO_IRQ_BASE, which was passed though pdata.
> We don't need to do this anymore, so we're pulling out the
> property from the structure.
> 
> Cc: arm@kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Requesting an ACK from the ARM SoC maintainers on this patch.

This patch on its own doesn't apply cleanly at all to arm-soc, I'm guessing
because I need the rest of the series. With the presumption that you're not
going to cause grief from sfr due to excessive conflicts. I.e. please try
merging with arm-soc for-next to see how bad it is:

patch 11-14:

Acked-by: Olof Johansson <olof@lixom.net>

If it's conflict-heavy, we'll stage a topic branch that we can both
pull in.  I'm guessing/hoping that won't be the case though.


-Olof
