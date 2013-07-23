Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3GWBdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:33:46 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:43330 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab3GWBdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:33:45 -0400
Date: Tue, 23 Jul 2013 10:33:43 +0900
From: Simon Horman <horms@verge.net.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 19/22] ARM: shmobile: r8a7779: Remove '0x's from R8A7779
 DTS file
Message-ID: <20130723013343.GG16481@verge.net.au>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-19-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374490361-25769-19-git-send-email-lee.jones@linaro.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 11:52:38AM +0100, Lee Jones wrote:
> Cc: Simon Horman <horms+renesas@verge.net.au>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

Let me know if you want me to take this through the renesas tree.

> ---
>  arch/arm/boot/dts/r8a7779.dtsi | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/r8a7779.dtsi b/arch/arm/boot/dts/r8a7779.dtsi
> index 7f146c6..86bd487 100644
> --- a/arch/arm/boot/dts/r8a7779.dtsi
> +++ b/arch/arm/boot/dts/r8a7779.dtsi
> @@ -65,7 +65,7 @@
>  		sense-bitfield-width = <2>;
>  	};
>  
> -	i2c0: i2c@0xffc70000 {
> +	i2c0: i2c@ffc70000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "renesas,rmobile-iic";
> @@ -74,7 +74,7 @@
>  		interrupts = <0 79 0x4>;
>  	};
>  
> -	i2c1: i2c@0xffc71000 {
> +	i2c1: i2c@ffc71000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "renesas,rmobile-iic";
> @@ -83,7 +83,7 @@
>  		interrupts = <0 82 0x4>;
>  	};
>  
> -	i2c2: i2c@0xffc72000 {
> +	i2c2: i2c@ffc72000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "renesas,rmobile-iic";
> @@ -92,7 +92,7 @@
>  		interrupts = <0 80 0x4>;
>  	};
>  
> -	i2c3: i2c@0xffc73000 {
> +	i2c3: i2c@ffc73000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "renesas,rmobile-iic";
> -- 
> 1.8.1.2
> 
