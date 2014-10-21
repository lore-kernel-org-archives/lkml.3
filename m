Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbaJUO1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:27:22 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35787 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631AbaJUO1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:27:20 -0400
Message-ID: <54466D33.1010501@baylibre.com>
Date: Tue, 21 Oct 2014 22:26:59 +0800
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Update entry for omap related .dts files
 to cover new SoCs
References: <1413901462-32181-1-git-send-email-nm@ti.com>
In-Reply-To: <1413901462-32181-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,

On 21/10/2014 22:24, Nishanth Menon wrote:
> DRA7(including AM5x) and AM47x series are handled under OMAP umbrella.
> These SoC support and dts have been added since 3.14 kernel and Pull
> requests for these have come in from OMAP till date.
>
> So just ensure that get_maintainers can pick up this list as well.
>
> Cc: Benoît Cousson <bcousson@baylibre.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: linux-omap@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Nishanth Menon <nm@ti.com>

Acked-by: Benoît Cousson <bcousson@baylibre.com>


Thanks,
Benoit

> ---
>   MAINTAINERS |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a20df9b..e205bd2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6585,6 +6585,9 @@ L:	devicetree@vger.kernel.org
>   S:	Maintained
>   F:	arch/arm/boot/dts/*omap*
>   F:	arch/arm/boot/dts/*am3*
> +F:	arch/arm/boot/dts/*am4*
> +F:	arch/arm/boot/dts/*am5*
> +F:	arch/arm/boot/dts/*dra7*
>
>   OMAP CLOCK FRAMEWORK SUPPORT
>   M:	Paul Walmsley <paul@pwsan.com>
>


-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
