Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbaIKVIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:08:15 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63878 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbaIKVIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:08:13 -0400
Message-ID: <54120F34.6010708@gmail.com>
Date: Thu, 11 Sep 2014 23:08:04 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: berlin: enable timer 1 for sched_clock
References: <1410274069-24922-1-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1410274069-24922-1-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 04:47 PM, Antoine Tenart wrote:
> Enable timer 1 to be the source for the sched_clock, allowing to have a
> more precise value than 1/HZ.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Applied to berlin/dt.

For the record, I managed to configure UTF-8, so feel free to add the
accent back to your name ;)

I applied the last patches with it already.

Sebastian

> ---
>  arch/arm/boot/dts/berlin2q.dtsi | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index a216cb621ebc..e22b99a3a796 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -247,7 +247,6 @@
>  				reg = <0x2c14 0x14>;
>  				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
> -				status = "disabled";
>  			};
>  
>  			timer2: timer@2c28 {
> 

