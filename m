Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab3G3FG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:06:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54665 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab3G3FG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:06:26 -0400
Message-ID: <51F749B0.7020802@ti.com>
Date: Tue, 30 Jul 2013 10:35:52 +0530
From: Gururaja Hebbar <gururaja.hebbar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <benoit.cousson@linaro.org>
CC: <khilman@linaro.org>, <tony@atomide.com>, <benoit.cousson@gmail.com>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>
Subject: Re: [Patch V2 4/4] ARM: dts: AM33XX: update rtc node compatibility
References: <1372841225-18813-1-git-send-email-gururaja.hebbar@ti.com> <1372841225-18813-5-git-send-email-gururaja.hebbar@ti.com>
In-Reply-To: <1372841225-18813-5-git-send-email-gururaja.hebbar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/3/2013 2:17 PM, Hebbar Gururaja wrote:
> Since AM33xx  RTC IP has RTC_IRQWAKEEN to support Alarm Wake-up.
>
> Update the rtc compatible property to "ti,am3352-rtc" to enable handling
> of this feature inside rtc-omap driver.

The other 2 rtc driver related patches have been pulled up. If you have 
no comments, can you please pull this up.

Regards
Gururaja

>
> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> ---
> :100644 100644 77aa1b0... dde180a... M	arch/arm/boot/dts/am33xx.dtsi
>   arch/arm/boot/dts/am33xx.dtsi |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 77aa1b0..dde180a 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -297,7 +297,7 @@
>   		};
>
>   		rtc@44e3e000 {
> -			compatible = "ti,da830-rtc";
> +			compatible = "ti,am3352-rtc";
>   			reg = <0x44e3e000 0x1000>;
>   			interrupts = <75
>   				      76>;
>

