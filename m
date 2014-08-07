Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbaHGQwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:52:25 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39417 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaHGQwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:52:23 -0400
Message-ID: <53E3AEC4.2050405@kernel.org>
Date: Thu, 07 Aug 2014 17:52:20 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, heiko@sntech.de, knaack.h@gmx.de,
        t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 3/3] dt-bindings: samsung: exynos_adc: Remove un-necessary
 white-sapce
References: <1406551442-15186-1-git-send-email-cw00.choi@samsung.com> <1406551442-15186-4-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1406551442-15186-4-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/14 13:44, Chanwoo Choi wrote:
> This patch remove un-necessary white-sapce to code clean.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Applied to the togreg branch of iio.git. Obviously this didn't
need to go through my tree, but as it is so trivial it might
as well do so.

J
> ---
>  Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index 709efaa..5ee0266 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -30,7 +30,7 @@ Required properties:
>  			- The base address and range of ADC register
>  			- The base address and range of ADC_PHY register (every
>  			  SoC except for s3c24xx/s3c64xx ADC)
> -- interrupts: 		Contains the interrupt information for the timer. The
> +- interrupts:		Contains the interrupt information for the timer. The
>  			format is being dependent on which interrupt controller
>  			the Samsung device uses.
>  - #io-channel-cells = <1>; As ADC has multiple outputs
> 
