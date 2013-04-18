Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967211Ab3DRJa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:30:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36424 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267Ab3DRJaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:30:24 -0400
Message-ID: <516FBD18.3060501@ti.com>
Date: Thu, 18 Apr 2013 11:30:00 +0200
From: =?ISO-8859-1?Q?Vincent_Stehl=E9?= <v-stehle@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dan Murphy <dmurphy@ti.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] ARM:dts:omap4-panda:Update the LED support for the
 panda DTS
References: <1366229760-4808-1-git-send-email-dmurphy@ti.com>
In-Reply-To: <1366229760-4808-1-git-send-email-dmurphy@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 10:16 PM, Dan Murphy wrote:
> The GPIO for LED D1 on the omap4-panda a1-a3 rev and the omap4-panda-es
> are different.
(..)
> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
> index 03bd60d..0c48f6b 100644
> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
(..)
> @@ -135,6 +136,25 @@
>  			0xf0 0x118     /* i2c4_sda PULLUP | INPUTENABLE | MODE0 */
>  		>;
>  	};
> +
> +	led_gpio_pins: pinmux_leds_pins {
> +		pinctrl-single,pins = <
> +		>;
> +	};
> +};

Hi,

FYI, there was a recent discussion precisely on this topic, where Tomy
suggested to remove the empty section:
http://marc.info/?l=linux-omap&m=136546635409232&w=2

Apart from that, I just tested your patch on top of Tomy's
omap-for-v3.10/dt branch and it is working fine for me on PandaBoards
EA3, A4 and ES.

Tested-by: Vincent Stehlé <v-stehle@ti.com>

Best regards,

V.

