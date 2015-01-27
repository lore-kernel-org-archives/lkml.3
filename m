Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbbA0Ueo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:34:44 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:37894 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759305AbbA0Uen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:34:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?= <niso@kth.se>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com
Subject: Re: [PATCH v2 4/4] ARM: shmobile: emev2-kzm9d: Add PFC information for uart1
Date: Tue, 27 Jan 2015 22:35:22 +0200
Message-ID: <2057603.FzjFJsB71b@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1421583604-27256-5-git-send-email-niso@kth.se>
References: <1421583604-27256-1-git-send-email-niso@kth.se> <1421583604-27256-5-git-send-email-niso@kth.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Sunday 18 January 2015 13:20:04 Niklas Söderlund wrote:
> Configure the pinmux on kzm9d to use the serial connector for uart1.
> 
> Signed-off-by: Niklas Söderlund <niso@kth.se>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  arch/arm/boot/dts/emev2-kzm9d.dts | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/emev2-kzm9d.dts
> b/arch/arm/boot/dts/emev2-kzm9d.dts index 667d323..1944627 100644
> --- a/arch/arm/boot/dts/emev2-kzm9d.dts
> +++ b/arch/arm/boot/dts/emev2-kzm9d.dts
> @@ -94,3 +94,16 @@
>  		vdd33a-supply = <&reg_3p3v>;
>  	};
>  };
> +
> +&pfc {
> +	uart1_pins: uart@e1030000 {
> +		renesas,groups = "uart1_ctrl", "uart1_data";
> +		renesas,function = "uart1";
> +	};
> +};
> +
> +&uart1 {
> +	pinctrl-0 = <&uart1_pins>;
> +	pinctrl-names = "default";
> +	status = "okay";
> +};

-- 
Regards,

Laurent Pinchart

