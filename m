Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaJPUWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:22:38 -0400
Received: from gloria.sntech.de ([95.129.55.99]:42466 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaJPUWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:22:36 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        xjq@rock-chips.com, hj@rock-chips.com, huangtao@rock-chips.com,
        dkl@rock-chips.com, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/2] init some clock rate from dts for rk3288
Date: Thu, 16 Oct 2014 22:22:16 +0200
Message-ID: <7367250.umrZo9GlUH@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1412916630-8256-1-git-send-email-kever.yang@rock-chips.com>
References: <1412916630-8256-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 9. Oktober 2014, 21:50:28 schrieb Kever Yang:
> This patch add init rate for PLLs and some bus clock  from dts for rk3288,
> add two clock rate of 400M and 500M into rate table for we will use it.
> We need Doug's patch to make "aclk_cpu" get set properly:
> 	<https://patchwork.kernel.org/patch/5038781/>
> 
> Changes in v2:
> - change the PLL setting of 400M to meet the constraints of TRM
> - add review and test tag
> - add some explanation in commit message
> 
> Kever Yang (2):
>   clk: rockchip: add 400MHz and 500MHz for rk3288 clock rate
>   ARM: dts: enable init rate for clock

I've added both patches to my wip branches for clock and dts.
I've also adapted the subject of the 2nd one to

	"ARM: dts: rockchip: enable init rate for clock"

because otherwise people reading the log won't be able to see which subarch 
this is.


Heiko

> 
>  arch/arm/boot/dts/rk3288.dtsi     | 10 ++++++++++
>  drivers/clk/rockchip/clk-rk3288.c |  2 ++
>  2 files changed, 12 insertions(+)

