Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3AWGds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:33:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57692 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab3AWGdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:33:38 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: "Cousson, Benoit" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/3] ARM: dts: AM33XX: Add ELM node
Thread-Topic: [PATCH 1/3] ARM: dts: AM33XX: Add ELM node
Thread-Index: AQHN+BiSg3rT3cb7bkyuyKHoPZ/ajJhWXrmg
Date: Wed, 23 Jan 2013 06:32:15 +0000
Deferred-Delivery: Wed, 23 Jan 2013 06:32:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA62B2D@DBDE01.ent.ti.com>
References: <1358491295-4022-1-git-send-email-avinashphilip@ti.com>
	<1358491295-4022-2-git-send-email-avinashphilip@ti.com>
 <877gn69sb9.fsf@dell.be.48ers.dk>
In-Reply-To: <877gn69sb9.fsf@dell.be.48ers.dk>
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

On Tue, Jan 22, 2013 at 02:17:38, Peter Korsgaard wrote:
> >>>>> "Philip" == Philip Avinash <avinashphilip@ti.com> writes:
> 
>  Philip> From: "Philip, Avinash" <avinashphilip@ti.com>
>  Philip> Add ELM data node to AM33XX device tree file.
> 
>  Philip> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
>  Philip> ---
>  Philip>  arch/arm/boot/dts/am33xx.dtsi |    8 ++++++++
>  Philip>  1 file changed, 8 insertions(+)
> 
>  Philip> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
>  Philip> index c2f14e8..eaef5e7 100644
>  Philip> --- a/arch/arm/boot/dts/am33xx.dtsi
>  Philip> +++ b/arch/arm/boot/dts/am33xx.dtsi
>  Philip> @@ -385,5 +385,13 @@
>  Philip>  				mac-address = [ 00 00 00 00 00 00 ];
>  Philip>  			};
>  Philip>  		};
>  Philip> +
>  Philip> +		elm: elm@48080000 {
>  Philip> +			compatible	= "ti,am33xx-elm";
> 
> Please drop the <tab> after compatible.

I will replace with space and submit another version

> 
> Other than that it looks goood.
> 
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

Thanks
Avinash

> 
> -- 
> Bye, Peter Korsgaard
> 

