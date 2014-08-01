Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaHAU2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:28:20 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:52884 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaHAU2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:28:18 -0400
MIME-Version: 1.0
In-Reply-To: <1406868897-26874-5-git-send-email-afaerber@suse.de>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
	<1406868897-26874-5-git-send-email-afaerber@suse.de>
Date: Fri, 1 Aug 2014 13:28:17 -0700
X-Google-Sender-Auth: DmGLXhxLnyaE6Dnp5Sc2_iW1FO8
Message-ID: <CAD=FV=V4hQeGvE9+O2EY8KGvDj3SJKfOZGes4gKpHfg=xz1h4A@mail.gmail.com>
Subject: Re: [PATCH v5 04/10] ARM: dts: Fill in bootargs for exynos5250-snow
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber <afaerber@suse.de> wrote:
> exynos5250-cros-common.dtsi had an empty /chosen node.
> Fill in exemplary boot arguments.
>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v5: New
>  Cleanup for /chosen node moved into -snow.dts.
>
>  arch/arm/boot/dts/exynos5250-snow.dts | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index 7680d5e03fb3..c4b0c73c736d 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -27,6 +27,7 @@
>         };
>
>         chosen {
> +               bootargs = "console=tty1";

As mentioned earlier, I don't think this is a particularly useful
change.  Just this boot argument is not enough to boot with anyway, so
listing it doesn't really help anyone.  In theory you could make some
assertion about what the "most popular" boot device and filesystem is,
but it seems unlikely to cover the majority of the cases.

I won't NAK this change myself, but I certainly won't push for it.

-Doug
