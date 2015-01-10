Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbbAJQeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 11:34:31 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59194 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbAJQea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 11:34:30 -0500
Message-ID: <54B15493.5030406@wwwdotorg.org>
Date: Sat, 10 Jan 2015 09:34:27 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bart Tanghe <bart.tanghe@thomasmore.be>, lee@kernel.org
CC: thierry.reding@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: dts: add bcm2835-pwm bindings
References: <1420628458-11459-1-git-send-email-bart.tanghe@thomasmore.be>
In-Reply-To: <1420628458-11459-1-git-send-email-bart.tanghe@thomasmore.be>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 04:00 AM, Bart Tanghe wrote:
> To probe the bcm2835-pwm driver properly, this dts bindings has to be added 
> to the bcm2835 dtsi file.
> In expectation of a bcm2835 clock driver, I've added fixed-clock clock binding.

> diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi

> +		pwm: pwm@7e20e000 {
> +			compatible = "brcm,bcm2835-pwm";
> +			reg = <0x7e20c000 0x28>;
> +			clocks = <&clk_pwm>;
> +			#pwm-cells = <2>;
> +			status = "disabled";
> +		};

Can the nodes be kept sorted by reg value; I think this should be added
between the existing i2c@20205000 and sdhci@7e300000 nodes.

Aside from that,
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
