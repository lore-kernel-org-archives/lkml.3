Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3KNPms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:42:48 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:53526 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab3KNPmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:42:40 -0500
Date: Thu, 14 Nov 2013 16:37:25 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] ARM: dove: Fix typo in device_type property of phy node
Message-ID: <20131114153725.GL21691@lunn.ch>
References: <1384440899-3622-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384440899-3622-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 02:54:59PM +0000, Srinivas Kandagatla wrote:
> This patch fixes a typo for device_type property of phy node.
> This can work as of today but once a checks are added in generic code
> this typo will stop phy from working.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Acked-by: Andrew Lunn <andrew@lunn.ch>

> ---
>  arch/arm/boot/dts/dove.dtsi |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
> index cc27916..b4a6559 100644
> --- a/arch/arm/boot/dts/dove.dtsi
> +++ b/arch/arm/boot/dts/dove.dtsi
> @@ -481,7 +481,7 @@
>  			status = "disabled";
>  
>  			ethphy: ethernet-phy {
> -				device-type = "ethernet-phy";
> +				device_type = "ethernet-phy";
>  				/* set phy address in board file */
>  			};
>  		};
> -- 
> 1.7.6.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
