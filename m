Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224Ab3BGRkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:40:00 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49876 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030237Ab3BGRjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:39:55 -0500
Date: Thu, 7 Feb 2013 17:39:49 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Anil Kumar <anilk4.v@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "thomas@tomweber.eu" <thomas@tomweber.eu>
Subject: Re: [PATCH] ARM: dts: add minimal DT support for DevKit8000
Message-ID: <20130207173949.GA21723@e106331-lin.cambridge.arm.com>
References: <1360246297-5500-1-git-send-email-anilk4.v@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1360246297-5500-1-git-send-email-anilk4.v@gmail.com>
Thread-Topic: [PATCH] ARM: dts: add minimal DT support for DevKit8000
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Feb 2013 17:39:52.0780 (UTC) FILETIME=[22B4E8C0:01CE055A]
X-MC-Unique: 113020717395401301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a couple of minor comments.

On Thu, Feb 07, 2013 at 02:11:37PM +0000, Anil Kumar wrote:
> DevKit8000 is a beagle board clone from Timll, sold by
> armkits.com. The DevKit8000 has RS232 serial port, LCD, DVI-D,
> S-Video, Ethernet, SD/MMC, keyboard, camera, SPI, I2C, USB and
> JTAG interface.
> 
> This patch adds the basic DT support for devkit8000. At this time, Information
> of twl4030, MMC1, I2C1, leds and there pim mux information are added.
> 
> Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
> Tested-by: Thomas Weber <thomas@tomweber.eu>
> ---
> 
>  -This patch is based on top of kernel 3.8-rc5.
> 
>  -Tested on Devkit8000.
> 

[...]

> diff --git a/arch/arm/boot/dts/omap3-devkit8000.dts b/arch/arm/boot/dts/omap3-devkit8000.dts
> new file mode 100644
> index 0000000..9864fd7
> --- /dev/null
> +++ b/arch/arm/boot/dts/omap3-devkit8000.dts
> @@ -0,0 +1,125 @@
> +/*
> + * Anil Kumar <anilk4.v@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +/dts-v1/;
> +
> +/include/ "omap3.dtsi"
> +/ {
> +	model = "TI OMAP3 Devkit8000";

Should this not be "TimLL Devkit8000" ?

> +	compatible = "ti,omap3-devkit8000", "ti,omap3";

"timll,devkit8000" ?

[...]

Thanks,
Mark.

