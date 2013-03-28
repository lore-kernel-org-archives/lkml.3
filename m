Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3C1Mmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:42:37 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:40715 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab3C1Mmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:42:32 -0400
Date: Thu, 28 Mar 2013 21:42:28 +0900
From: Simon Horman <horms@verge.net.au>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Jamie Iles <jamie@jamieiles.com>, Barry Song <baohua.song@csr.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: remove mach .init_irq for irqchip_init users
Message-ID: <20130328124228.GA29616@verge.net.au>
References: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com>
 <1364463704-13692-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364463704-13692-3-git-send-email-maxime.ripard@free-electrons.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 10:41:44AM +0100, Maxime Ripard wrote:
> Now that the arm core code calls irqchip_init, we can remove it from all
> the machines that were using it.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-bcm/board_bcm.c                  |    1 -
>  arch/arm/mach-msm/board-dt-8660.c              |    1 -
>  arch/arm/mach-msm/board-dt-8960.c              |    1 -
>  arch/arm/mach-nomadik/cpu-8815.c               |    1 -
>  arch/arm/mach-picoxcell/common.c               |    1 -
>  arch/arm/mach-prima2/common.c                  |    1 -
>  arch/arm/mach-shmobile/board-kzm9g-reference.c |    1 -
>  arch/arm/mach-shmobile/setup-emev2.c           |    1 -
>  arch/arm/mach-shmobile/setup-sh73a0.c          |    1 -
>  arch/arm/mach-spear/spear1310.c                |    1 -
>  arch/arm/mach-spear/spear1340.c                |    1 -
>  arch/arm/mach-spear/spear300.c                 |    1 -
>  arch/arm/mach-spear/spear310.c                 |    1 -
>  arch/arm/mach-spear/spear320.c                 |    1 -
>  arch/arm/mach-spear/spear6xx.c                 |    1 -
>  arch/arm/mach-vexpress/v2m.c                   |    1 -
>  arch/arm/mach-virt/virt.c                      |    1 -
>  arch/arm/mach-zynq/common.c                    |    1 -
>  18 files changed, 18 deletions(-)

mach-shmobile portion:

Acked-by: Simon Horman <horms+renesas@verge.net.au>

I have some new users of this queued up for v3.10.
How should we handle that?

In particular:

arch/arm/mach-shmobile/setup-r8a73a4.c
arch/arm/mach-shmobile/intc-r8a7779.c
arch/arm/mach-shmobile/setup-r8a7778.c

You can find these in the renesas-next-20130328 tag of
my renesas tree on kernel.org. They are or will soon
be in linux-next.

