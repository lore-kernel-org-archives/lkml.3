Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbbAMUAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:00:05 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:49948 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbAMUAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:00:03 -0500
MIME-Version: 1.0
In-Reply-To: <1418219670-18283-1-git-send-email-geert+renesas@glider.be>
References: <1418219670-18283-1-git-send-email-geert+renesas@glider.be>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 13 Jan 2015 13:59:40 -0600
Message-ID: <CAL_JsqL7mWBwkHSrC5wg+ux8U7=C=LbsWv5qBC1AWLNH_LD-5A@mail.gmail.com>
Subject: Re: [PATCH trivial 1/3] ARM: dt: GIC: Spelling s/specific/specifier/, s/flaggs/flags/
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 7:54 AM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Rob Herring <robh+dt@kernel.org>

Applied for 3.20. Thanks.

> ---
>  include/dt-bindings/interrupt-controller/arm-gic.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/dt-bindings/interrupt-controller/arm-gic.h b/include/dt-bindings/interrupt-controller/arm-gic.h
> index 1ea1b702fec2c49f..d4110d5caa3efde4 100644
> --- a/include/dt-bindings/interrupt-controller/arm-gic.h
> +++ b/include/dt-bindings/interrupt-controller/arm-gic.h
> @@ -7,14 +7,14 @@
>
>  #include <dt-bindings/interrupt-controller/irq.h>
>
> -/* interrupt specific cell 0 */
> +/* interrupt specifier cell 0 */
>
>  #define GIC_SPI 0
>  #define GIC_PPI 1
>
>  /*
>   * Interrupt specifier cell 2.
> - * The flaggs in irq.h are valid, plus those below.
> + * The flags in irq.h are valid, plus those below.
>   */
>  #define GIC_CPU_MASK_RAW(x) ((x) << 8)
>  #define GIC_CPU_MASK_SIMPLE(num) GIC_CPU_MASK_RAW((1 << (num)) - 1)
> --
> 1.9.1
>
