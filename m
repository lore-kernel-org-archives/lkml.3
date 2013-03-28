Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3C1SYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:24:08 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:39101 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3C1SYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:24:05 -0400
Message-ID: <51548AC2.1010802@free-electrons.com>
Date: Thu, 28 Mar 2013 19:24:02 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
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
References: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com> <1364463704-13692-3-git-send-email-maxime.ripard@free-electrons.com> <20130328124228.GA29616@verge.net.au>
In-Reply-To: <20130328124228.GA29616@verge.net.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

Le 28/03/2013 13:42, Simon Horman a écrit :
> On Thu, Mar 28, 2013 at 10:41:44AM +0100, Maxime Ripard wrote:
>> Now that the arm core code calls irqchip_init, we can remove it from all
>> the machines that were using it.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>  arch/arm/mach-bcm/board_bcm.c                  |    1 -
>>  arch/arm/mach-msm/board-dt-8660.c              |    1 -
>>  arch/arm/mach-msm/board-dt-8960.c              |    1 -
>>  arch/arm/mach-nomadik/cpu-8815.c               |    1 -
>>  arch/arm/mach-picoxcell/common.c               |    1 -
>>  arch/arm/mach-prima2/common.c                  |    1 -
>>  arch/arm/mach-shmobile/board-kzm9g-reference.c |    1 -
>>  arch/arm/mach-shmobile/setup-emev2.c           |    1 -
>>  arch/arm/mach-shmobile/setup-sh73a0.c          |    1 -
>>  arch/arm/mach-spear/spear1310.c                |    1 -
>>  arch/arm/mach-spear/spear1340.c                |    1 -
>>  arch/arm/mach-spear/spear300.c                 |    1 -
>>  arch/arm/mach-spear/spear310.c                 |    1 -
>>  arch/arm/mach-spear/spear320.c                 |    1 -
>>  arch/arm/mach-spear/spear6xx.c                 |    1 -
>>  arch/arm/mach-vexpress/v2m.c                   |    1 -
>>  arch/arm/mach-virt/virt.c                      |    1 -
>>  arch/arm/mach-zynq/common.c                    |    1 -
>>  18 files changed, 18 deletions(-)
> 
> mach-shmobile portion:
> 
> Acked-by: Simon Horman <horms+renesas@verge.net.au>

Thanks!

> 
> I have some new users of this queued up for v3.10.
> How should we handle that?

Since the old behaviour is preserved, I guess it doesn't matter much,
and one of us can always make a followup patch on top of these patches.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
