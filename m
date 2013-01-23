Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3AWGdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:33:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36264 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab3AWGdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:33:37 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: "Cousson, Benoit" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "zonque@gmail.com" <zonque@gmail.com>
Subject: RE: [PATCH 2/3] ARM: dts: AM33XX: Add GPMC node
Thread-Topic: [PATCH 2/3] ARM: dts: AM33XX: Add GPMC node
Thread-Index: AQHN+BqQGFR8rGFA9EKrIHW1IAKIBJhWdeBQ
Date: Wed, 23 Jan 2013 06:32:12 +0000
Deferred-Delivery: Wed, 23 Jan 2013 06:32:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA62B27@DBDE01.ent.ti.com>
References: <1358491295-4022-1-git-send-email-avinashphilip@ti.com>
	<1358491295-4022-3-git-send-email-avinashphilip@ti.com>
 <8738xu9rni.fsf@dell.be.48ers.dk>
In-Reply-To: <8738xu9rni.fsf@dell.be.48ers.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 02:31:53, Peter Korsgaard wrote:
> >>>>> "Philip" == Philip Avinash <avinashphilip@ti.com> writes:
> 
>  Philip> From: "Philip, Avinash" <avinashphilip@ti.com>
>  Philip> Add GPMC data node to AM33XX device tree file.
> 
>  Philip> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
>  Philip> ---
>  Philip>  arch/arm/boot/dts/am33xx.dtsi |   12 ++++++++++++
>  Philip>  1 file changed, 12 insertions(+)
> 
>  Philip> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
>  Philip> index eaef5e7..f4209d8 100644
>  Philip> --- a/arch/arm/boot/dts/am33xx.dtsi
>  Philip> +++ b/arch/arm/boot/dts/am33xx.dtsi
>  Philip> @@ -393,5 +393,17 @@
>  Philip>  			ti,hwmods = "elm";
>  Philip>  			status = "disabled";
>  Philip>  		};
>  Philip> +
>  Philip> +		gpmc: gpmc@50000000 {
>  Philip> +			compatible = "ti,am3352-gpmc";
>  Philip> +			ti,hwmods = "gpmc";
>  Philip> +			reg = <0x50000000 0x2000>;
>  Philip> +			interrupts = <100>;
>  Philip> +			num-cs = <8>;
> 
> Next to Jan's comment about am335x having 7 cs signals, I just realized
> the difference in compatible string between the gpmc and elm. The gpmc
> refers to a real device (which is afaik how it should be done), but the
> elm compatible is simply ti,am33xx-elm.
> 
> Presumably it should have been ti,am3352-elm in the binding instead?

I thought of following the file name convention. I will correct to "ti,am3352-elm"

> 
> Other than that it looks fine.
> 
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

Thanks
Avinash

> 
> -- 
> Bye, Peter Korsgaard
> 

