Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbaCTUlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:41:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56794 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaCTUlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:41:11 -0400
Message-ID: <532B5224.8010900@ti.com>
Date: Thu, 20 Mar 2014 16:40:04 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, <dwmw2@infradead.org>,
        <computersforpeace@gmail.com>, <galak@codeaurora.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <grygorii.strashko@ti.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <m-karicheri2@ti.com>
Subject: Re: [PATCH v2] ARM: dts: k2hk-evm: set ubifs partition size for 512M
 NAND
References: <1395346813-13439-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1395346813-13439-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2014 04:20 PM, Ivan Khoronzhuk wrote:
> From: Murali Karicheri <m-karicheri2@ti.com>
> 
> The UBIFS partition size was incorrectly defined as for 128M NAND,
> but on k2hk-evm installed NAND flash size is 512M.
> Hence, correct it.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
> 
> Just cut from series
> v1:
> [PATCH 1/3] ARM: dts: k2hk-evm: set ubifs partition size for 512M NAND
> https://lkml.org/lkml/2014/3/20/462
> 
Applied to for_3.15/fixes

>  arch/arm/boot/dts/k2hk-evm.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/k2hk-evm.dts b/arch/arm/boot/dts/k2hk-evm.dts
> index 1a1335b..949ef7d 100644
> --- a/arch/arm/boot/dts/k2hk-evm.dts
> +++ b/arch/arm/boot/dts/k2hk-evm.dts
> @@ -133,7 +133,7 @@
>  
>  			partition@180000 {
>  				label = "ubifs";
> -				reg = <0x180000 0x7E80000>;
> +				reg = <0x180000 0x1fe80000>;
>  			};
>  		};
>  	};
> 

