Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbaEFPUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:20:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26088 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaEFPUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:20:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19kf2YOSzb4cUaNJRVHpa/n
Date: Tue, 6 May 2014 08:20:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: mark.hambleton@broadcom.com, mark.brown@linaro.org,
        eduardo.valentin@ti.com, mporter@linaro.org, lsk-interest@linaro.org,
        linaro-kernel@linaro.org,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/19] arm: dts: add cooling properties on omap4430 cpu
 node
Message-ID: <20140506152007.GC18474@atomide.com>
References: <1395744572-20014-1-git-send-email-alex.shi@linaro.org>
 <1395744572-20014-11-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395744572-20014-11-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Shi <alex.shi@linaro.org> [140325 03:54]:
> From: Eduardo Valentin <eduardo.valentin@ti.com>
> 
> OMAP4430 devices can reach high temperatures and thus
> needs to have cpufreq-cooling on systems running on it.
> 
> This patch adds the required cooling device properties
> so that cpufreq-cpu0 driver loads the cooling device.

Alex, what's the status of this series? I could not find
the complete thread, so wondering what to do with patches
09 - 13?

Regards,

Tony
 
> Cc: "Benoît Cousson" <bcousson@baylibre.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-omap@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> (cherry picked from commit 72af5e6d0c3e01655c1c1fc7c7ca94a2b663611e)
> 
> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>  arch/arm/boot/dts/omap443x.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap443x.dtsi b/arch/arm/boot/dts/omap443x.dtsi
> index cccf39a..d2deba0 100644
> --- a/arch/arm/boot/dts/omap443x.dtsi
> +++ b/arch/arm/boot/dts/omap443x.dtsi
> @@ -22,6 +22,11 @@
>  				1008000 1375000
>  			>;
>  			clock-latency = <300000>; /* From legacy driver */
> +
> +			/* cooling options */
> +			cooling-min-level = <0>;
> +			cooling-max-level = <3>;
> +			#cooling-cells = <2>; /* min followed by max */
>  		};
>  	};
>  };
> -- 
> 1.8.1.2
> 
