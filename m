Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab3LFUwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:52:50 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48841 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab3LFUws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:52:48 -0500
MIME-Version: 1.0
In-Reply-To: <1386350983-13281-1-git-send-email-wens@csie.org>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
From: Michal Suchanek <hramrach@gmail.com>
Date: Fri, 6 Dec 2013 21:52:06 +0100
Message-ID: <CAOMqctQLnky=K+uhJNVPTGq+MJVNFoG1OW5Zxo7P2MvrRf_Cug@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH 00/10] net: stmmac: Add sun7i GMAC glue layer
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 December 2013 18:29, Chen-Yu Tsai <wens@csie.org> wrote:
> Hi,
>
> This patch series adds Allwinner sun7i support to stmmac.
> The Allwinner sun7i SoC A20 integrates an early version of
> dwmac IP from Synopsys. On top of that is a hardware glue
> layer. This layer needs to be configured before the dwmac
> can be used.

...

> Comments?
>
> Thanks,
>
> wens
>
>
> Chen-Yu Tsai (10):
>   net: stmmac: Enable stmmac main clock when probing hardware
>   net: stmmac: Honor DT parameter to force DMA store and forward mode
>   net: stmmac: Use platform data tied with compatible strings
>   net: stmmac: sunxi platfrom extensions for GMAC in Allwinner A20 SoC's
>   ARM: dts: sun7i: Add GMAC controller node to sun7i DTSI
>   ARM: dts: sun7i: Add pin muxing options for the GMAC
>   ARM: dts: sun7i: cubietruck: Enable the GMAC
>   ARM: dts: sun7i: cubieboard2: Enable GMAC instead of EMAC
>   ARM: dts: sun7i: olinuxino-micro: Enable GMAC instead of EMAC
>   ARM: dts: sun7i: Add ethernet alias for GMAC

Tested-By: Michal Suchanek <hramrach@gmail.com>

Works for me with RGMII and MII phy on top of 3.13rc3.

Thanks

Michal
