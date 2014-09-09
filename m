Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaIII0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:26:39 -0400
Received: from gloria.sntech.de ([95.129.55.99]:46445 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbaIII0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:26:37 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Sonny Rao <sonnyrao@chromium.org>, stefan@agner.ch,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, Addy Ke <addy.ke@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: dts: Add mshc aliases for rk3288
Date: Tue, 09 Sep 2014 10:28:36 +0200
Message-ID: <18318098.Hm4yenW6Sf@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1409785523-12209-1-git-send-email-dianders@chromium.org>
References: <1409785523-12209-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 3. September 2014, 16:05:23 schrieb Doug Anderson:
> It's convenient (and less confusing to people reading logs) if the
> eMMC port on rk3288 is consistenly marked with mmc0 and the sdmmc port
> on rk3288 is consistently marked with mmc1.  Add the appropriate
> aliases.

Added to my v3.18-next/dts branch

> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Sonny Rao <sonnyrao@chromium.org>
> ---
> 
> Changes in v2:
> - Use mshc aliases now
> - Adds sdio0/1 aliases since those are in the dts.
> 
>  arch/arm/boot/dts/rk3288.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 5f866e0..2c5d01f 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -29,6 +29,10 @@
>  		i2c3 = &i2c3;
>  		i2c4 = &i2c4;
>  		i2c5 = &i2c5;
> +		mshc0 = &emmc;
> +		mshc1 = &sdmmc;
> +		mshc2 = &sdio0;
> +		mshc3 = &sdio1;
>  		serial0 = &uart0;
>  		serial1 = &uart1;
>  		serial2 = &uart2;

