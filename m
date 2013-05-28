Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3E1VZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:25:17 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:54256 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477Ab3E1VZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:14 -0400
Message-ID: <51A520B5.8040803@gmail.com>
Date: Tue, 28 May 2013 22:25:09 +0100
From: Jon Hunter <jgchunter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>
Subject: Re: [PATCH v2 11/14] Documentation: dt: binding: omap: am43x timer
References: <cover.1369658705.git.afzal@ti.com> <223d90dc9eeab13d8496690d336cdf0f7d27cd22.1369658705.git.afzal@ti.com>
In-Reply-To: <223d90dc9eeab13d8496690d336cdf0f7d27cd22.1369658705.git.afzal@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27/05/13 15:37, Afzal Mohammed wrote:
> AM43x timer bindings.
> 
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
>  Documentation/devicetree/bindings/arm/omap/timer.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/omap/timer.txt b/Documentation/devicetree/bindings/arm/omap/timer.txt
> index d02e27c..70cb398 100644
> --- a/Documentation/devicetree/bindings/arm/omap/timer.txt
> +++ b/Documentation/devicetree/bindings/arm/omap/timer.txt
> @@ -14,6 +14,8 @@ Required properties:
>  			ti,omap5430-timer (applicable to OMAP543x devices)
>  			ti,am335x-timer	(applicable to AM335x devices)
>  			ti,am335x-timer-1ms (applicable to AM335x devices)
> +			"ti,am4372-timer-1ms", "ti,am335x-timer-1ms" for AM43x 1ms timer
> +			"ti,am4372-timer", "ti,am335x-timer" for AM43x timers other than 1ms one
>  
>  - reg:			Contains timer register address range (base address and
>  			length).

If you are adding more compatibility strings, then this implies that the
AM43x timers are not 100% compatible with any other device listed (such
as am335x or any omap device). That's fine but you should state that in
the changelog. If the AM43x timer registers are 100% compatible with
existing devices you should not add these.

Jon

