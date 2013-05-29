Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab3E2PyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:54:23 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60349 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3E2PyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:54:21 -0400
Date: Wed, 29 May 2013 16:54:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: Re: [PATCH 3/4] ARM: u8540: Add device tree support for bh1780
Message-ID: <20130529155415.GG3012@gmail.com>
References: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
 <1369834407-30762-4-git-send-email-gabriel.fernandez.st@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369834407-30762-4-git-send-email-gabriel.fernandez.st@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013, Gabriel Fernandez wrote:

> From: Gabriel Fernandez <gabriel.fernandez@st.com>
> 
> This patch adds DT probing of the light sensor bh1780
> for u8540.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
> ---
>  arch/arm/boot/dts/ccu8540-uib-v3.dts | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/ccu8540-uib-v3.dts b/arch/arm/boot/dts/ccu8540-uib-v3.dts
> index 422a292..dc90571 100644
> --- a/arch/arm/boot/dts/ccu8540-uib-v3.dts
> +++ b/arch/arm/boot/dts/ccu8540-uib-v3.dts
> @@ -16,6 +16,11 @@
>  };
>  
>  &i2c2 {
> +	bh1780@29 {
> +		compatible = "bh1780";
> +		reg = <0x29>;
> +		vcc-supply = <&ab8500_ldo_aux1_reg>;
> +	};
>  
>  	lp5521@32 {
>  		compatible = "national,lp5521";

For this patch, not withstanding the ones prior:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
