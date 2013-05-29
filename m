Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab3E2Pu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:50:27 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:54116 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab3E2PuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:50:23 -0400
Date: Wed, 29 May 2013 16:50:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: Re: [PATCH 1/4] ARM: ux540: Add ccu8540-uib-v3 Device Tree Machine
Message-ID: <20130529155018.GE3012@gmail.com>
References: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
 <1369834407-30762-2-git-send-email-gabriel.fernandez.st@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369834407-30762-2-git-send-email-gabriel.fernandez.st@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013, Gabriel Fernandez wrote:

> From: Gabriel Fernandez <gabriel.fernandez@st.com>
> 
> This board includes the U8540 platform and specifies only the
> ST-Ericsson UIB version 3.

I'm confused by this.

Is it a new board, or just a UIB?

> ---
>  arch/arm/boot/dts/Makefile           |  1 +
>  arch/arm/boot/dts/ccu8540-uib-v3.dts | 16 ++++++++++++++++
>  2 files changed, 17 insertions(+)
>  create mode 100644 arch/arm/boot/dts/ccu8540-uib-v3.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 1995988..29cb5db 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -159,6 +159,7 @@ dtb-$(CONFIG_ARCH_U8500) += snowball.dtb \
>  	hrefprev60.dtb \
>  	hrefv60plus.dtb \
>  	ccu8540.dtb \
> +	ccu8540-uib-v3.dtb 	\
>  	ccu9540.dtb
>  dtb-$(CONFIG_ARCH_SHMOBILE) += emev2-kzm9d.dtb \
>  	r8a7740-armadillo800eva.dtb \
> diff --git a/arch/arm/boot/dts/ccu8540-uib-v3.dts b/arch/arm/boot/dts/ccu8540-uib-v3.dts
> new file mode 100644
> index 0000000..4b4982e
> --- /dev/null
> +++ b/arch/arm/boot/dts/ccu8540-uib-v3.dts

If this is a UIB, it should be an include file (*.dtsi).

> @@ -0,0 +1,16 @@
> +/*
> + * Copyright 2012 ST-Ericsson AB
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#include "ccu8540.dts"

No, the other way round.

ccu8540.dts should include this one.

> +/ {
> +	model = "ST-Ericsson U8540 platform with device tree UIB v3";
> +};

This patch doesn't actually do anything.

Fix it up, so it at least as some functionality.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
