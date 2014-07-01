Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbaGANUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:20:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51920 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780AbaGANUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:20:53 -0400
Date: Tue, 1 Jul 2014 14:18:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] ARM: dts: dove: enable lcd0 on SolidRun CuBox
Message-ID: <20140701131858.GD6064@leverpostej>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1404219871-18419-4-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404219871-18419-4-git-send-email-sebastian.hesselbarth@gmail.com>
Thread-Topic: [PATCH 3/4] ARM: dts: dove: enable lcd0 on SolidRun CuBox
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 02:04:30PM +0100, Sebastian Hesselbarth wrote:
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

This clock wasn't mentioned in the binding document. Could you please
amend that?

Thanks,
Mark.
