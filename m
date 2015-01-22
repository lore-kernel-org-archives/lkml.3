Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbbAVW2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:28:22 -0500
Received: from smtp1.ore.mailhop.org ([54.68.34.165]:54886 "EHLO
	smtp1.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbbAVW2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:28:19 -0500
X-Mail-Handler: DuoCircle Outbound SMTP
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@duocircle.com (see https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information for abuse reporting information)
X-MHO-User: U2FsdGVkX19FoypSs7pM/1bUbqcGkFCN
Date: Thu, 22 Jan 2015 13:37:48 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: bcousson@baylibre.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com, neilb@suse.de
Subject: Re: [PATCH 06/13] ARM: dts: omap3-gta04: Enable power-off using
 twl4030
Message-ID: <20150122213748.GX7718@atomide.com>
References: <1421959099-28319-1-git-send-email-marek@goldelico.com>
 <1421959099-28319-7-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421959099-28319-7-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [150122 12:42]:
> From: "H. Nikolaus Schaller" <hns@goldelico.com>
> 
> Enabled poweroff through PMIC on GTA04.
> 
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  arch/arm/boot/dts/omap3-gta04.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
> index 0265474..b56c85b 100644
> --- a/arch/arm/boot/dts/omap3-gta04.dtsi
> +++ b/arch/arm/boot/dts/omap3-gta04.dtsi
> @@ -209,6 +209,11 @@
>  			codec {
>  			};
>  		};
> +
> +		twl_power: power {
> +			compatible = "ti,twl4030-power";
> +			ti,use_poweroff;
> +		};
>  	};
>  };
>  

No need to change this patch, but you may want to get things working
with ti,twl4030-power-idle-osc-off for PM if you're running it on
batteries :)

Regards,

Tony
