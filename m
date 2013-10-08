Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3JHSSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 14:18:37 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:47176 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3JHSSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 14:18:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/mS9rsla01HzjXce5ZIrtJ
Date: Tue, 8 Oct 2013 11:18:27 -0700
From: Tony Lindgren <tony@atomide.com>
To: Afzal Mohammed <afzal@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, Benoit Cousson <bcousson@baylibre.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH RFC 5/6] ARM: dts: AM335x: prcm node (for reset)
Message-ID: <20131008181827.GH8313@atomide.com>
References: <cover.1378129416.git.afzal@ti.com>
 <00675d65eef61eb4222e6a461ef479ebbd1d4787.1378129416.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00675d65eef61eb4222e6a461ef479ebbd1d4787.1378129416.git.afzal@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Afzal Mohammed <afzal@ti.com> [130902 07:30]:
> Add AM335x prcm node with reset binding.

Please put the .dts changes into a separate series from
driver changes so the driver maintainers don't accidentally
queue also the .dts changes. This is to avoid pointless
self-inflicted merge conflicts.

Regards,

Tony
 
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
>  arch/arm/boot/dts/am33xx.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 4701e3c..c2ccf94 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -530,6 +530,12 @@
>  			#size-cells = <1>;
>  			status = "disabled";
>  		};
> +
> +		prcm: prcm@44e00000 {
> +			compatible = "ti,am3352-prcm";
> +			reg = <0x44e00000 0x1300>;
> +			#reset-cells = <1>;
> +		};
>  	};
>  
>  	clocks {
> -- 
> 1.8.3.4
> 
