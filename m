Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3HPQJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:09:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39566 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab3HPQJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:09:26 -0400
Message-ID: <520E4E92.7070902@ti.com>
Date: Fri, 16 Aug 2013 21:38:50 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] ARM: davinci: da850: add DT node for ethernet
References: <1376662262-21795-1-git-send-email-prabhakar.csengg@gmail.com> <1376662262-21795-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1376662262-21795-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/2013 7:41 PM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> Add ethernet device tree node information and pinmux for mii to da850 by
> providing interrupt details and local mac address.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  arch/arm/boot/dts/da850-evm.dts |    5 +++++
>  arch/arm/boot/dts/da850.dtsi    |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> index 1f8cfdd..44f3fbc 100644
> --- a/arch/arm/boot/dts/da850-evm.dts
> +++ b/arch/arm/boot/dts/da850-evm.dts
> @@ -96,6 +96,11 @@
>  			pinctrl-0 = <&mdio_pins>;
>  			bus_freq = <2200000>;
>  		};
> +		ethernet: emac@1e20000 {

You misunderstood what Sergei said. This should be:

	eth0: ethernet@1e20000 {

Thanks,
Sekhar
