Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaKJRqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:46:31 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36338 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaKJRqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:46:30 -0500
Message-ID: <5460F9EF.5010605@gmail.com>
Date: Mon, 10 Nov 2014 09:46:23 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Radek Dostal <radek.dostal@streamunlimited.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] ARM: dts: bcm63138: change "interupts" to "interrupts"
References: <1415637358-24378-1-git-send-email-radek.dostal@streamunlimited.com>
In-Reply-To: <1415637358-24378-1-git-send-email-radek.dostal@streamunlimited.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 08:35 AM, Radek Dostal wrote:
> all other nodes in bcm63138.dtsi use "interrupts", this had to be just a typo
> which never got noticed, even it may have quite some consequences.
> 
> Signed-off-by: Radek Dostal <radek.dostal@streamunlimited.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  Hi all,
> 
>  when running git grep with typo, I spotted this typo inDT binding, which 
>  looks obviously wrong to me. Sorry I do not have the board to test it, but 
>  I am pretty sure the patch is correct.
> 
>  I hope I included, right people get_maintainer.pl showed bit too many.
> 
>  Thanks,
>  Radek
> 
>  arch/arm/boot/dts/bcm63138.dtsi |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/bcm63138.dtsi b/arch/arm/boot/dts/bcm63138.dtsi
> index f3bb2dd..d2d8e94 100644
> --- a/arch/arm/boot/dts/bcm63138.dtsi
> +++ b/arch/arm/boot/dts/bcm63138.dtsi
> @@ -102,7 +102,7 @@
>  		twd_watchdog: watchdog@1e620 {
>  			compatible = "arm,cortex-a9-twd-wdt";
>  			reg = <0x1e620 0x20>;
> -			interupts = <GIC_PPI 14 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupts = <GIC_PPI 14 IRQ_TYPE_LEVEL_HIGH>;
>  		};
>  	};
>  
> 

