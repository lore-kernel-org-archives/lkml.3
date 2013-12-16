Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3LPNqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:46:51 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:53354 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab3LPNqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:46:48 -0500
MIME-Version: 1.0
In-Reply-To: <1387078509-14156-3-git-send-email-dt.tangr@gmail.com>
References: <1387078509-14156-1-git-send-email-dt.tangr@gmail.com>
	<1387078509-14156-3-git-send-email-dt.tangr@gmail.com>
Date: Mon, 16 Dec 2013 07:46:47 -0600
Message-ID: <CAL_JsqJ1HTccZ0-QLAXnWOvMYHsO_GjzKtYbbqp7_0c_H3e_NA@mail.gmail.com>
Subject: Re: [PATCH 3/3] devicetree: bindings: document lsi,zevio-usb
From: Rob Herring <robherring2@gmail.com>
To: dt.tangr@gmail.com
Cc: Linux USB List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 9:35 PM,  <dt.tangr@gmail.com> wrote:
> From: Daniel Tang <dt.tangr@gmail.com>
>
>
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>

A few minor things below. Otherwise:

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  .../devicetree/bindings/usb/ci-hdrc-zevio.txt         |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt
>
> diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt
> new file mode 100644
> index 0000000..1a005eb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/ci-hdrc-zevio.txt
> @@ -0,0 +1,17 @@
> +* LSI Zevio USB OTG Controller
> +
> +Required properties:
> +- compatible: Should be "lsi,zevio-usb"
> +- reg: Should contain registers location and length
> +- interrupts: Should contain controller interrupt
> +
> +Recommended properies:

To be consistent, should be "optional" rather than recommended.

s/properies/properties/

> +- vbus-supply: regulator for vbus
> +
> +Examples:
> +               usb0: usb@B0000000 {
> +                       reg = <0xB0000000 0x1000>;

lower case hex is preferred.

> +                       compatible = "lsi,zevio-usb";
> +                       interrupts = <8>;
> +                       vbus-supply = <&vbus_reg>;
> +               };
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
