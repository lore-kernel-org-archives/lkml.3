Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaATUZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 15:25:35 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34476 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaATUZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 15:25:33 -0500
MIME-Version: 1.0
In-Reply-To: <1387638743-12278-1-git-send-email-marek@goldelico.com>
References: <1387638743-12278-1-git-send-email-marek@goldelico.com>
Date: Mon, 20 Jan 2014 21:25:31 +0100
Message-ID: <CAAfyv36Y+N9DpFWPf5SLmJv=fcnvktVPd30QBOEsNGFdr-A0xA@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: omap3-gta04: Add EOC irq gpio line handling.
From: Belisko Marek <marek.belisko@gmail.com>
To: Benoit Cousson <bcousson@baylibre.com>, Tony Lindgren <tony@atomide.com>,
        robh+dt@kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping? Benoit can you please merge this trivial update. Thanks.

On Sat, Dec 21, 2013 at 4:12 PM, Marek Belisko <marek@goldelico.com> wrote:
> BMP085 EOC (End Of Conversion) irq line is connected to
> gpio113 on gta04. Set irq properties to have driver using irq
> instead polling for EOC.
>
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  arch/arm/boot/dts/omap3-gta04.dts | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
> index b9b55c9..7a8e37d 100644
> --- a/arch/arm/boot/dts/omap3-gta04.dts
> +++ b/arch/arm/boot/dts/omap3-gta04.dts
> @@ -92,6 +92,8 @@
>         bmp085@77 {
>                 compatible = "bosch,bmp085";
>                 reg = <0x77>;
> +               interrupt-parent = <&gpio4>;
> +               interrupts = <17 IRQ_TYPE_EDGE_RISING>;
>         };
>
>         /* leds */
> --
> 1.8.4.2
>

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
