Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3EMJqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:46:11 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51336 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab3EMJqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <1368438253-28218-8-git-send-email-maxime.ripard@free-electrons.com>
References: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com>
	<1368438253-28218-8-git-send-email-maxime.ripard@free-electrons.com>
Date: Mon, 13 May 2013 15:16:06 +0530
Message-ID: <CAKohpo=TRXoZ2L0vUor4834QNbf0UxaB9AVYY-r-3mAKYTgjig@mail.gmail.com>
Subject: Re: [PATCH 07/14] ARM: spear: Remove init_irq declaration in machine description
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 May 2013 15:14, Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
> specified") removed the need to explictly setup the init_irq field in
> the machine description when using only irqchip_init. Remove that
> declaration for spear as well.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-spear/spear1310.c | 1 -
>  arch/arm/mach-spear/spear1340.c | 1 -
>  arch/arm/mach-spear/spear300.c  | 1 -
>  arch/arm/mach-spear/spear310.c  | 1 -
>  arch/arm/mach-spear/spear320.c  | 1 -
>  arch/arm/mach-spear/spear6xx.c  | 1 -
>  6 files changed, 6 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
