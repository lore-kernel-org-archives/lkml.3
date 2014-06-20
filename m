Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934388AbaFTErS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:47:18 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:56534 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaFTErQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:47:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140619215557.784621009@linutronix.de>
References: <20140619215347.139324048@linutronix.de>
	<20140619215557.784621009@linutronix.de>
Date: Fri, 20 Jun 2014 10:17:15 +0530
X-Google-Sender-Auth: AsaEq8jZXDgfGlrBGHD9QZHfNvo
Message-ID: <CAOh2x=k_r3oH-bFPYctarQci3G6yi2U7WxhsR7U2UvU+BzMAjw@mail.gmail.com>
Subject: Re: [patch 1/2] dts: spear: Fix sdhci compatible
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 3:26 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Make it match the bindings and the implementation.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/arm/boot/dts/spear320.dtsi |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/arch/arm/boot/dts/spear320.dtsi
> ===================================================================
> --- linux.orig/arch/arm/boot/dts/spear320.dtsi
> +++ linux/arch/arm/boot/dts/spear320.dtsi
> @@ -48,7 +48,7 @@
>                 };
>
>                 sdhci@70000000 {
> -                       compatible = "st,sdhci-spear";
> +                       compatible = "st,spear300-sdhci";
>                         reg = <0x70000000 0x100>;
>                         interrupts = <10>;
>                         interrupt-parent = <&shirq>;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
