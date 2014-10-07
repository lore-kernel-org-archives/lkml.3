Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaJGQ3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:29:09 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:41503 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaJGQ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:29:06 -0400
MIME-Version: 1.0
In-Reply-To: <1412695169-22815-5-git-send-email-darshanapadmadas@gmail.com>
References: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com> <1412695169-22815-5-git-send-email-darshanapadmadas@gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 7 Oct 2014 11:28:42 -0500
Message-ID: <CAL_Jsq+BFFfh8AHc=mhm5hapHCN++5F4fHZG+KJFBGLYaOyagg@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] arch: arm: boot: dts: Added correct vendor-prefix
 with device name to compatible property
To: Darshana Padmadas <darshanapadmadas@gmail.com>
Cc: opw-kernel@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 10:19 AM, Darshana Padmadas
<darshanapadmadas@gmail.com> wrote:
> This patch adds the correct vendor-prefix listed in Documentation/devicetree/bindings/vendor-prefixes.txt
> with the device name to compatible property.

It would be nice if the subject and msg gave some clue as to which
binding and platform you are changing. Look at prior commits and
follow their pattern for subject.

Rob

>
> Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>
> ---
>  arch/arm/boot/dts/tegra30-cardhu.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
> index 2063795..dcc6c75 100644
> --- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
> +++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
> @@ -187,7 +187,7 @@
>
>                 /* ALS and Proximity sensor */
>                 isl29028@44 {
> -                       compatible = "isil,isl29028";
> +                       compatible = "isl,isl29028";
>                         reg = <0x44>;
>                         interrupt-parent = <&gpio>;
>                         interrupts = <TEGRA_GPIO(L, 0) IRQ_TYPE_LEVEL_HIGH>;
> --
> 1.9.1
>
