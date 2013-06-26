Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3FZEHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:07:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58420 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3FZEHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:07:41 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Fernandes, Joel" <joelagnel@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Chris Ball <cjb@laptop.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH 5/5] mmc: omap_hsmmc: Add reg-offset to bindings
 documentation
Thread-Topic: [PATCH 5/5] mmc: omap_hsmmc: Add reg-offset to bindings
 documentation
Thread-Index: AQHOcgwxbYUj9dwpPUuW5SjrhzTkVplHYJfw
Date: Wed, 26 Jun 2013 04:06:31 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC43DB1@DBDE04.ent.ti.com>
References: <1372209901-6715-1-git-send-email-joelagnel@ti.com>
In-Reply-To: <1372209901-6715-1-git-send-email-joelagnel@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 06:55:01, Fernandes, Joel wrote:
> From: Joel A Fernandes <agnel.joel@gmail.com>
> 
> A new reg-offset property was added to account for register offsets
> in some omap-hsmmc's. Document the new property.
> 

Small nitpick

I usually get feedback that any driver DT changes and the associated
Binding doc update should come in one single patch for better readability.

In this case, I believe it would be patch 1/5 & 5/5


Regards, 
Gururaja


> Signed-off-by: Joel A Fernandes <agnel.joel@gmail.com>
> ---
>  .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> index 8c8908a..33f4b1e 100644
> --- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> +++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> @@ -20,6 +20,9 @@ ti,dual-volt: boolean, supports dual voltage cards
>  ti,non-removable: non-removable slot (like eMMC)
>  ti,needs-special-reset: Requires a special softreset sequence
>  ti,needs-special-hs-handling: HSMMC IP needs special setting for handling High Speed
> +reg-offset: Supplementing the common reg property (described in bindings/mmc/mmc.txt),
> +some omap-hsmmc's can start an offset from reg but are otherwise identical to others.
> +The registers between start to offset are considered reserved.
>  dmas: List of DMA specifiers with the controller specific format
>  as described in the generic DMA client binding. A tx and rx
>  specifier is required.
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
