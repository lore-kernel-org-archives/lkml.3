Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaLWKMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:12:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57208 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaLWKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:12:07 -0500
Message-ID: <54993FC0.3090705@ti.com>
Date: Tue, 23 Dec 2014 15:41:12 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vignesh R <vigneshr@ti.com>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: DRA7X: drop id property in pcie_phy
References: <1418721771-31184-1-git-send-email-vigneshr@ti.com> <1418721771-31184-3-git-send-email-vigneshr@ti.com>
In-Reply-To: <1418721771-31184-3-git-send-email-vigneshr@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tuesday 16 December 2014 02:52 PM, Vignesh R wrote:
> Since phyid is no longer used by pcie driver, this field can be dropped
> from the DT.
> 
> Signed-off-by: Vignesh R <vigneshr@ti.com>

Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/dra7.dtsi | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 63bf99be1762..889e3023e68f 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -1111,7 +1111,6 @@
>  					      "wkupclk", "refclk",
>  					      "div-clk", "phy-div";
>  				#phy-cells = <0>;
> -				id = <1>;
>  				ti,hwmods = "pcie1-phy";
>  			};
>  
> @@ -1132,7 +1131,6 @@
>  					      "div-clk", "phy-div";
>  				#phy-cells = <0>;
>  				ti,hwmods = "pcie2-phy";
> -				id = <2>;
>  				status = "disabled";
>  			};
>  		};
> 
