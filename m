Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946053AbaD3QoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:44:11 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:64097 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbaD3QoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:44:07 -0400
MIME-Version: 1.0
In-Reply-To: <1398848110-6152-3-git-send-email-gautam.vivek@samsung.com>
References: <1398848110-6152-1-git-send-email-gautam.vivek@samsung.com>
	<1398848110-6152-3-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 30 Apr 2014 22:14:06 +0530
Message-ID: <CAK9yfHyj9xyNiSo6S2bDnF+k1oB3LR+aG+N7Kgg60VPKYKjnjQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: dts: Add usb2phy to Exynos 5250
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On 30 April 2014 14:25, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> From: Kamil Debski <k.debski@samsung.com>
>
> Add support to PHY of USB2 of the Exynos 5250 SoC.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> [gautam.vivek@samsung.com: Split the usb phy entries from
> syscon entries from earlier patch: dts: Add usb2phy to Exynos 5250]
> [gautam.vivek@samsung.com: Added phy entry for OHCI also along with EHCI]
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>
> Changes from v7:
> None
>
>  arch/arm/boot/dts/exynos5250.dtsi |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 70f0cd5..51e554c 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -563,6 +563,14 @@
>
>                 clocks = <&clock CLK_USB2>;
>                 clock-names = "usbhost";
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               port@0 {
> +                       reg = <0>;
> +                       phys = <&usb2_phy_gen 1>;
> +                       phy-names = "host";
> +                       status = "ok";

This should be "okay".

> +               };
>         };
>
>         usb@12120000 {
> @@ -572,6 +580,14 @@
>
>                 clocks = <&clock CLK_USB2>;
>                 clock-names = "usbhost";
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               port@0 {
> +                       reg = <0>;
> +                       phys = <&usb2_phy_gen 1>;
> +                       phy-names = "host";
> +                       status = "ok";

ditto.


-- 
With warm regards,
Sachin
