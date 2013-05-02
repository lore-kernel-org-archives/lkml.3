Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3EBJQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 05:16:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45036 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3EBJQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 05:16:15 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Gupta, Pekon" <pekon@ti.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "Philip, Avinash" <avinashphilip@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "zonque@gmail.com" <zonque@gmail.com>,
        "jacmet@sunsite.dk" <jacmet@sunsite.dk>
Subject: RE: [v3, 3/3] ARM: dts: AM33XX: Add NAND flash device tree data to
 am335x-evm
Thread-Topic: [v3, 3/3] ARM: dts: AM33XX: Add NAND flash device tree data to
 am335x-evm
Thread-Index: AQHORxHR0U17iAuBwkSDpiBbIRVGepjxnE8w
Date: Thu, 2 May 2013 09:15:15 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EC747E9@DBDE04.ent.ti.com>
References: <1367484501-3623-1-git-send-email-pekon@ti.com>
In-Reply-To: <1367484501-3623-1-git-send-email-pekon@ti.com>
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


> -----Original Message-----
> From: Gupta, Pekon
> Sent: Thursday, May 02, 2013 2:18 PM
> To: Gupta, Pekon; Cousson, Benoit; tony@atomide.com;
> linux@arm.linux.org.uk
> Cc: Philip, Avinash; linux-omap@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; Nori, Sekhar; Hebbar, Gururaja; Hiremath,
> Vaibhav; zonque@gmail.com; jacmet@sunsite.dk
> Subject: [v3, 3/3] ARM: dts: AM33XX: Add NAND flash device tree data to
> am335x-evm
> 
> From: avinash philip <avinashphilip@ti.com>
> 
> NAND flash connected in am335x-evm on GPMC controller. This patch adds
> device tree node in am3355-evm with GPMC contoller timing for NAND
> flash
> interface, NAND partition table, ECC scheme, elm handle id.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Signed-off-by: Gupta, Pekon <pekon@ti.com>
> ---
>  arch/arm/boot/dts/am335x-evm.dts | 95
> ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 95 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am335x-evm.dts
> b/arch/arm/boot/dts/am335x-evm.dts
> index d649644..07761fd 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -44,6 +44,26 @@
>  				0x154 0x27	/* spi0_d0.gpio0_3, INPUT | MODE7
> */
>  			>;
>  		};
> +
> +		nandflash_pins_s0: nandflash_pins_s0 {
> +			pinctrl-single,pins = <
> +				0x0 0x30	/* gpmc_ad0.gpmc_ad0, INPUT |
> PULLUP | MODE0 */
> +				0x4 0x30	/* gpmc_ad1.gpmc_ad1, INPUT |
> PULLUP | MODE0 */
> +				0x8 0x30	/* gpmc_ad2.gpmc_ad2, INPUT |
> PULLUP | MODE0 */
> +				0xc 0x30	/* gpmc_ad3.gpmc_ad3, INPUT |
> PULLUP | MODE0 */
> +				0x10 0x30	/* gpmc_ad4.gpmc_ad4, INPUT |
> PULLUP | MODE0 */
> +				0x14 0x30	/* gpmc_ad5.gpmc_ad5, INPUT |
> PULLUP | MODE0 */
> +				0x18 0x30	/* gpmc_ad6.gpmc_ad6, INPUT |
> PULLUP | MODE0 */
> +				0x1c 0x30	/* gpmc_ad7.gpmc_ad7, INPUT |
> PULLUP | MODE0 */
> +				0x70 0x30	/* gpmc_wait0.gpmc_wait0, INPUT |
> PULLUP | MODE0 */
> +				0x74 0x37	/* gpmc_wpn.gpio0_30, INPUT |
> PULLUP | MODE7 */
> +				0x7c 0x8	/* gpmc_csn0.gpmc_csn0,  PULL DISA
> */
> +				0x90 0x8	/* gpmc_advn_ale.gpmc_advn_ale,
> PULL DISA */
> +				0x94 0x8	/* gpmc_oen_ren.gpmc_oen_ren, PULL
> DISA */
> +				0x98 0x8	/* gpmc_wen.gpmc_wen, PULL DISA */
> +				0x9c 0x8	/* gpmc_be0n_cle.gpmc_be0n_cle,
> PULL DISA */
> +			>;
> +		};
>  	};
> 
>  	ocp {
> @@ -102,6 +122,81 @@
>  				reg = <0x48>;
>  			};
>  		};
> +
> +		elm: elm@48080000 {
> +			status = "okay";
> +		};
> +
> +		gpmc: gpmc@50000000 {
> +			status = "okay";
> +			pinctrl-0 = <&nandflash_pins_s0>;

It would be good, if you label this pin configuration with 'default' name,
as below -


pinctrl-names = "default";

Thanks,
Vaibhav

> +			ranges = <0 0 0x08000000 0x10000000>;	/* CS0:
> NAND */
> +			nand@0,0 {
> +				reg = <0 0 0>; /* CS0, offset 0 */
> +				nand-bus-width = <8>;
> +				ti,nand-ecc-opt = "bch8";
> +
> +				gpmc,sync-clk = <0>;
> +				gpmc,cs-on = <0>;
> +				gpmc,cs-rd-off = <44>;
> +				gpmc,cs-wr-off = <44>;
> +				gpmc,adv-on = <6>;
> +				gpmc,adv-rd-off = <34>;
> +				gpmc,adv-wr-off = <44>;
> +				gpmc,we-off = <40>;
> +				gpmc,oe-off = <54>;
> +				gpmc,access = <64>;
> +				gpmc,rd-cycle = <82>;
> +				gpmc,wr-cycle = <82>;
> +				gpmc,wr-access = <40>;
> +				gpmc,wr-data-mux-bus = <0>;
> +
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +				elm_id = <&elm>;
> +
> +				/* MTD partition table */
> +				partition@0 {
> +					label = "SPL1";
> +					reg = <0x00000000 0x000020000>;
> +				};
> +
> +				partition@1 {
> +					label = "SPL2";
> +					reg = <0x00020000 0x00020000>;
> +				};
> +
> +				partition@2 {
> +					label = "SPL3";
> +					reg = <0x00040000 0x00020000>;
> +				};
> +
> +				partition@3 {
> +					label = "SPL4";
> +					reg = <0x00060000 0x00020000>;
> +				};
> +
> +				partition@4 {
> +					label = "U-boot";
> +					reg = <0x00080000 0x001e0000>;
> +				};
> +
> +				partition@5 {
> +					label = "environment";
> +					reg = <0x00260000 0x00020000>;
> +				};
> +
> +				partition@6 {
> +					label = "Kernel";
> +					reg = <0x00280000 0x00500000>;
> +				};
> +
> +				partition@7 {
> +					label = "File-System";
> +					reg = <0x00780000 0x0F880000>;
> +				};
> +			};
> +		};
>  	};
> 
>  	vbat: fixedregulator@0 {
> --
> 1.8.1

