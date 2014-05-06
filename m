Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaEFRXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:23:46 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:43111 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaEFRXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:23:44 -0400
MIME-Version: 1.0
In-Reply-To: <1399396211-25353-2-git-send-email-b.galvani@gmail.com>
References: <1399396211-25353-1-git-send-email-b.galvani@gmail.com>
	<1399396211-25353-2-git-send-email-b.galvani@gmail.com>
Date: Tue, 6 May 2014 12:23:43 -0500
Message-ID: <CAL_JsqJ0k2ke91oZwrDUS3YMq6rDE4n7qbnTidThJKMvEZ94mg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: dts: rockchip: add root compatible properties
From: Rob Herring <robherring2@gmail.com>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 12:10 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> Add the missing 'compatible' property to device tree root node of
>
>  - rk3066a-bqcurie2.dts
>  - rk3188-radxarock.dts
>
> and document the new values.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

Acked-by: Rob Herring <robh@kernel.org>

> ---
>
> v2:
>  - use mundoreader prefix instead of bq as suggested by Heiko Stuebner
>
>  Documentation/devicetree/bindings/arm/rockchip.txt |   10 ++++++++++
>  arch/arm/boot/dts/rk3066a-bqcurie2.dts             |    1 +
>  arch/arm/boot/dts/rk3188-radxarock.dts             |    1 +
>  3 files changed, 12 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/rockchip.txt
>
> diff --git a/Documentation/devicetree/bindings/arm/rockchip.txt b/Documentation/devicetree/bindings/arm/rockchip.txt
> new file mode 100644
> index 0000000..857f126
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/rockchip.txt
> @@ -0,0 +1,10 @@
> +Rockchip platforms device tree bindings
> +---------------------------------------
> +
> +- bq Curie 2 tablet:
> +    Required root node properties:
> +      - compatible = "mundoreader,bq-curie2", "rockchip,rk3066a";
> +
> +- Radxa Rock board:
> +    Required root node properties:
> +      - compatible = "radxa,rock", "rockchip,rk3188";
> diff --git a/arch/arm/boot/dts/rk3066a-bqcurie2.dts b/arch/arm/boot/dts/rk3066a-bqcurie2.dts
> index 035df40..afb3273 100644
> --- a/arch/arm/boot/dts/rk3066a-bqcurie2.dts
> +++ b/arch/arm/boot/dts/rk3066a-bqcurie2.dts
> @@ -18,6 +18,7 @@
>
>  / {
>         model = "bq Curie 2";
> +       compatible = "mundoreader,bq-curie2", "rockchip,rk3066a";
>
>         memory {
>                 reg = <0x60000000 0x40000000>;
> diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
> index 3ba1968..a5eee55 100644
> --- a/arch/arm/boot/dts/rk3188-radxarock.dts
> +++ b/arch/arm/boot/dts/rk3188-radxarock.dts
> @@ -17,6 +17,7 @@
>
>  / {
>         model = "Radxa Rock";
> +       compatible = "radxa,rock", "rockchip,rk3188";
>
>         memory {
>                 reg = <0x60000000 0x80000000>;
> --
> 1.7.10.4
>
