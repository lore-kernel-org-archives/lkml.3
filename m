Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbaGAPic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:38:32 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:51531 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622AbaGAPia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:38:30 -0400
Date: Tue, 1 Jul 2014 17:40:12 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: dts: dove: enable lcd0 on SolidRun CuBox
Message-ID: <20140701174012.11c60043@armhf>
In-Reply-To: <1404219871-18419-4-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1404219871-18419-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Jul 2014 15:04:30 +0200
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> From: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> This enables lcd0 on SolidRun CuBox which is connected to TDA998x
> HDMI transmitter. Also, set the external video clock connected to
> Si5351 clock generator.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/dove-cubox.dts |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
> index 7a70f4c..303a354 100644
> --- a/arch/arm/boot/dts/dove-cubox.dts
> +++ b/arch/arm/boot/dts/dove-cubox.dts
> @@ -134,3 +134,9 @@
>  	pinctrl-0 = <&pmx_audio1_i2s1_spdifo &pmx_audio1_extclk>;
>  	pinctrl-names = "default";
>  };
> +
> +&lcd0 {
> +	status = "okay";
> +	clocks = <&si5351 0>;
> +	clock-names = "ext_ref_clk_1";
> +};

My driver has "axiclk", "extclk0", "lcdpll" and "extclk1" as the clock
names. It is a bit shorter.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
