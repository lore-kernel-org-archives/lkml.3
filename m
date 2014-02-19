Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaBSRDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:03:23 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55418 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140AbaBSRDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:03:22 -0500
Date: Wed, 19 Feb 2014 17:02:51 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b.brezillon@overkiz.com" <b.brezillon@overkiz.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 3/8] ARM: at91: dt: sam9rl: Device Tree for the
 at91sam9rlek
Message-ID: <20140219170251.GB25079@e106331-lin.cambridge.arm.com>
References: <1392823951-26053-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1392823951-26053-4-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392823951-26053-4-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 03:32:26PM +0000, Alexandre Belloni wrote:
> Add a device tree for the at91sam9rl-ek. For now it supports:
>  - MMC
>  - dbgu
>  - usart1
>  - watchdog
>  - nand
>  - leds
>  - buttons
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/Makefile         |   2 +
>  arch/arm/boot/dts/at91sam9rlek.dts | 151 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 153 insertions(+)
>  create mode 100644 arch/arm/boot/dts/at91sam9rlek.dts

[...]

> +	clocks {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		main_clock: clock@0 {
> +			compatible = "atmel,osc", "fixed-clock";
> +			clock-frequency = <12000000>;
> +		};
> +	};

This has no reg. It shouldn't need the unit-address.

Thanks,
Mark.
