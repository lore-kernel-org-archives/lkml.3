Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaLMCG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 21:06:28 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35732 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaLMCG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 21:06:27 -0500
MIME-Version: 1.0
In-Reply-To: <1418408748-9797-6-git-send-email-vishnupatekar0510@gmail.com>
References: <1418408748-9797-1-git-send-email-vishnupatekar0510@gmail.com> <1418408748-9797-6-git-send-email-vishnupatekar0510@gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Sat, 13 Dec 2014 10:06:04 +0800
X-Google-Sender-Auth: 4PCT7WgxH0R-7g83hzARdGRwW0I
Message-ID: <CAGb2v65xpUhiMzSKu_1+JGNbg3oFdpw2EQ+JGUYkivCtG2O6gw@mail.gmail.com>
Subject: Re: [PATCHv3 5/5] ARM: sunxi: dts: Add note ps2 pins conflict with hdmi
To: VishnuPatekar <vishnupatekar0510@gmail.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans De Goede <hdegoede@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, benh@kernel.crashing.org,
        msalter@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>,
        ralf@linux-mips.org, Rob Herring <robh+dt@kernel.org>,
        jdelvare@suse.de, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 13, 2014 at 2:25 AM, VishnuPatekar
<vishnupatekar0510@gmail.com> wrote:
> 1. Please note that ps20 pins conflict with HDMI on Lime2 Board
> so, by deault ps20 and ps21 are disabled for Lime2 Board.
> There is no on board ps2 connector and these pins can be used
> for different purpose.
>
> Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
> ---
>  arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> index ed364d5..951b615 100644
> --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> @@ -112,7 +112,11 @@
>                         pinctrl-0 = <&uart0_pins_a>;
>                         status = "okay";
>                 };
> -
> +
> +               /* PS2 0 and PS2 1 are disabled by default; Please note that
> +               ps20 pins conflict with HDMI on Lime2 Board
> +               */
> +

Multi-line comments should be:

/*
 * line 1
 * line 2
 * ...
 */

And why is there a delete and insert for an empty line?
Weird... though git seems to ignore it when applying.

ChenYu

>                 i2c0: i2c@01c2ac00 {
>                         pinctrl-names = "default";
>                         pinctrl-0 = <&i2c0_pins_a>;
> --
> 1.7.9.5
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
