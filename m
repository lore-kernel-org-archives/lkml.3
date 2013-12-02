Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3LBJxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:53:46 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45574 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232Ab3LBJxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:53:43 -0500
Date: Mon, 2 Dec 2013 09:52:53 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alex Ling <kasimling@gmail.com>
Cc: "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM: dts: Add missing clock names for exynos4412
 dwmmc node
Message-ID: <20131202095253.GC12952@e106331-lin.cambridge.arm.com>
References: <1385892707-25063-1-git-send-email-kasimling@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385892707-25063-1-git-send-email-kasimling@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 01, 2013 at 10:11:47AM +0000, Alex Ling wrote:
> This patch adds "biu" and "ciu" clock names for exynos4412 dwmmc
> node. Without this patch, dwmmc host driver will skip enabling the
> two clocks and it will break dwmmc host function on exynos4412.
> Tested on FriendlyARM TINY4412 board.

The patch description is a little off; this patch adds the clocks as
well as the clock-names.

The patch itself looks fine to me.

Mark.

> 
> Signed-off-by: Alex Ling <kasimling@gmail.com>
> ---
>  arch/arm/boot/dts/exynos4412.dtsi |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
> index e743e67..67bef99 100644
> --- a/arch/arm/boot/dts/exynos4412.dtsi
> +++ b/arch/arm/boot/dts/exynos4412.dtsi
> @@ -67,5 +67,7 @@
>  		interrupts = <0 77 0>;
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> +		clocks = <&clock 301>, <&clock 149>;
> +		clock-names = "biu", "ciu";
>  	};
>  };
> -- 
> 1.7.9.5
> 
> 
