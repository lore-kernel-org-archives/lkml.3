Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab3GaXw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 19:52:57 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:32350
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845Ab3GaXwz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 19:52:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zcb8kzbb2dI98dI9371I936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de096h8275bh8275dh1de097hz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Wed, 31 Jul 2013 18:52:47 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] powerpc/fsl-booke: Rename b4qds.dts -> b4qds.dtsi.
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: <linux-kernel@vger.kernel.org>,
        Poonam Aggrwal <poonam.aggrwal@freescale.com>,
        Shaveta Leekha <shaveta@freescale.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Andy Fleming <afleming@freescale.com>,
        Ramneek Mehresh <ramneek.mehresh@freescale.com>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
References: <1369995280-20863-1-git-send-email-ian.campbell@citrix.com>
	<1375281925.7382.88.camel@kazak.uk.xensource.com>
In-Reply-To: <1375281925.7382.88.camel@kazak.uk.xensource.com> (from
	Ian.Campbell@citrix.com on Wed Jul 31 09:45:25 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1375314767.30721.120@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got it in my queue that I hope to send soon.

-Scott

On 07/31/2013 09:45:25 AM, Ian Campbell wrote:
> ping?
> 
> On Fri, 2013-05-31 at 11:14 +0100, Ian Campbell wrote:
> > This file is a common include for B4860 and B4420 but is not a  
> valid DTS itself:
> > 	  DTC     arch/powerpc/boot/b4qds.dtb
> > 	Error: arch/powerpc/boot/dts/b4qds.dts:35.1-2 syntax error
> > 	FATAL ERROR: Unable to parse input tree
> > 	make[1]: *** [arch/powerpc/boot/b4qds.dtb] Error 1
> > 	make: *** [b4qds.dtb] Error 2
> >
> > I spotted in build tests of device-tree.git, announcement
> > https://lkml.org/lkml/2013/4/24/209, which builds *.dts. Probably  
> no one would
> > do this this in real life on linux.git but it still seems worth  
> fixing.
> >
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > Cc: Shaveta Leekha <shaveta@freescale.com>
> > Cc: Minghuan Lian <Minghuan.Lian@freescale.com>
> > Cc: Andy Fleming <afleming@freescale.com>
> > Cc: Poonam Aggrwal <poonam.aggrwal@freescale.com>
> > Cc: Ramneek Mehresh <ramneek.mehresh@freescale.com>
> > Cc: Kumar Gala <galak@kernel.crashing.org>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: linuxppc-dev@lists.ozlabs.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/powerpc/boot/dts/b4420qds.dts |    2 +-
> >  arch/powerpc/boot/dts/b4860qds.dts |    2 +-
> >  arch/powerpc/boot/dts/b4qds.dts    |  169  
> ------------------------------------
> >  arch/powerpc/boot/dts/b4qds.dtsi   |  169  
> ++++++++++++++++++++++++++++++++++++
> >  4 files changed, 171 insertions(+), 171 deletions(-)
> >  delete mode 100644 arch/powerpc/boot/dts/b4qds.dts
> >  create mode 100644 arch/powerpc/boot/dts/b4qds.dtsi
> >
> > diff --git a/arch/powerpc/boot/dts/b4420qds.dts  
> b/arch/powerpc/boot/dts/b4420qds.dts
> > index 923156d..508dbdf 100644
> > --- a/arch/powerpc/boot/dts/b4420qds.dts
> > +++ b/arch/powerpc/boot/dts/b4420qds.dts
> > @@ -33,7 +33,7 @@
> >   */
> >
> >  /include/ "fsl/b4420si-pre.dtsi"
> > -/include/ "b4qds.dts"
> > +/include/ "b4qds.dtsi"
> >
> >  / {
> >  	model = "fsl,B4420QDS";
> > diff --git a/arch/powerpc/boot/dts/b4860qds.dts  
> b/arch/powerpc/boot/dts/b4860qds.dts
> > index 78907f3..6bb3707 100644
> > --- a/arch/powerpc/boot/dts/b4860qds.dts
> > +++ b/arch/powerpc/boot/dts/b4860qds.dts
> > @@ -33,7 +33,7 @@
> >   */
> >
> >  /include/ "fsl/b4860si-pre.dtsi"
> > -/include/ "b4qds.dts"
> > +/include/ "b4qds.dtsi"
> >
> >  / {
> >  	model = "fsl,B4860QDS";
> > diff --git a/arch/powerpc/boot/dts/b4qds.dts  
> b/arch/powerpc/boot/dts/b4qds.dts
> > deleted file mode 100644
> > index e6d2f8f..0000000
> > --- a/arch/powerpc/boot/dts/b4qds.dts
> > +++ /dev/null
> > @@ -1,169 +0,0 @@
> > -/*
> > - * B4420DS Device Tree Source
> > - *
> > - * Copyright 2012 Freescale Semiconductor, Inc.
> > - *
> > - * Redistribution and use in source and binary forms, with or  
> without
> > - * modification, are permitted provided that the following  
> conditions are met:
> > - *     * Redistributions of source code must retain the above  
> copyright
> > - *       notice, this list of conditions and the following  
> disclaimer.
> > - *     * Redistributions in binary form must reproduce the above  
> copyright
> > - *       notice, this list of conditions and the following  
> disclaimer in the
> > - *       documentation and/or other materials provided with the  
> distribution.
> > - *     * Neither the name of Freescale Semiconductor nor the
> > - *       names of its contributors may be used to endorse or  
> promote products
> > - *       derived from this software without specific prior written  
> permission.
> > - *
> > - *
> > - * ALTERNATIVELY, this software may be distributed under the terms  
> of the
> > - * GNU General Public License ("GPL") as published by the Free  
> Software
> > - * Foundation, either version 2 of that License or (at your  
> option) any
> > - * later version.
> > - *
> > - * This software is provided by Freescale Semiconductor "as is"  
> and any
> > - * express or implied warranties, including, but not limited to,  
> the implied
> > - * warranties of merchantability and fitness for a particular  
> purpose are
> > - * disclaimed. In no event shall Freescale Semiconductor be liable  
> for any
> > - * direct, indirect, incidental, special, exemplary, or  
> consequential damages
> > - * (including, but not limited to, procurement of substitute goods  
> or services;
> > - * loss of use, data, or profits; or business interruption)  
> however caused and
> > - * on any theory of liability, whether in contract, strict  
> liability, or tort
> > - * (including negligence or otherwise) arising in any way out of  
> the use of
> > - * this software, even if advised of the possibility of such  
> damage.
> > - */
> > -
> > -/ {
> > -	model = "fsl,B4QDS";
> > -	compatible = "fsl,B4QDS";
> > -	#address-cells = <2>;
> > -	#size-cells = <2>;
> > -	interrupt-parent = <&mpic>;
> > -
> > -	ifc: localbus@ffe124000 {
> > -		reg = <0xf 0xfe124000 0 0x2000>;
> > -		ranges = <0 0 0xf 0xe8000000 0x08000000
> > -			  2 0 0xf 0xff800000 0x00010000
> > -			  3 0 0xf 0xffdf0000 0x00008000>;
> > -
> > -		nor@0,0 {
> > -			#address-cells = <1>;
> > -			#size-cells = <1>;
> > -			compatible = "cfi-flash";
> > -			reg = <0x0 0x0 0x8000000>;
> > -			bank-width = <2>;
> > -			device-width = <1>;
> > -		};
> > -
> > -		nand@2,0 {
> > -			#address-cells = <1>;
> > -			#size-cells = <1>;
> > -			compatible = "fsl,ifc-nand";
> > -			reg = <0x2 0x0 0x10000>;
> > -
> > -			partition@0 {
> > -				/* This location must not be altered  */
> > -				/* 1MB for u-boot Bootloader Image */
> > -				reg = <0x0 0x00100000>;
> > -				label = "NAND U-Boot Image";
> > -				read-only;
> > -			};
> > -
> > -			partition@100000 {
> > -				/* 1MB for DTB Image */
> > -				reg = <0x00100000 0x00100000>;
> > -				label = "NAND DTB Image";
> > -			};
> > -
> > -			partition@200000 {
> > -				/* 10MB for Linux Kernel Image */
> > -				reg = <0x00200000 0x00A00000>;
> > -				label = "NAND Linux Kernel Image";
> > -			};
> > -
> > -			partition@c00000 {
> > -				/* 500MB for Root file System Image */
> > -				reg = <0x00c00000 0x1F400000>;
> > -				label = "NAND RFS Image";
> > -			};
> > -		};
> > -
> > -		board-control@3,0 {
> > -			compatible = "fsl,b4qds-fpga", "fsl,fpga-qixis";
> > -			reg = <3 0 0x300>;
> > -		};
> > -	};
> > -
> > -	memory {
> > -		device_type = "memory";
> > -	};
> > -
> > -	dcsr: dcsr@f00000000 {
> > -		ranges = <0x00000000 0xf 0x00000000 0x01052000>;
> > -	};
> > -
> > -	soc: soc@ffe000000 {
> > -		ranges = <0x00000000 0xf 0xfe000000 0x1000000>;
> > -		reg = <0xf 0xfe000000 0 0x00001000>;
> > -		spi@110000 {
> > -			flash@0 {
> > -				#address-cells = <1>;
> > -				#size-cells = <1>;
> > -				compatible = "sst,sst25wf040";
> > -				reg = <0>;
> > -				spi-max-frequency = <40000000>; /*  
> input clock */
> > -			};
> > -		};
> > -
> > -		sdhc@114000 {
> > -			/*Disabled as there is no sdhc connector on  
> B4420QDS board*/
> > -			status = "disabled";
> > -		};
> > -
> > -		i2c@118000 {
> > -			eeprom@50 {
> > -				compatible = "at24,24c64";
> > -				reg = <0x50>;
> > -			};
> > -			eeprom@51 {
> > -				compatible = "at24,24c256";
> > -				reg = <0x51>;
> > -			};
> > -			eeprom@53 {
> > -				compatible = "at24,24c256";
> > -				reg = <0x53>;
> > -			};
> > -			eeprom@57 {
> > -				compatible = "at24,24c256";
> > -				reg = <0x57>;
> > -			};
> > -			rtc@68 {
> > -				compatible = "dallas,ds3232";
> > -				reg = <0x68>;
> > -			};
> > -		};
> > -
> > -		usb@210000 {
> > -			dr_mode = "host";
> > -			phy_type = "ulpi";
> > -		};
> > -
> > -	};
> > -
> > -	pci0: pcie@ffe200000 {
> > -		reg = <0xf 0xfe200000 0 0x10000>;
> > -		ranges = <0x02000000 0 0xe0000000 0xc 0x00000000 0x0  
> 0x20000000
> > -			  0x01000000 0 0x00000000 0xf 0xf8000000 0x0  
> 0x00010000>;
> > -		pcie@0 {
> > -			ranges = <0x02000000 0 0xe0000000
> > -				  0x02000000 0 0xe0000000
> > -				  0 0x20000000
> > -
> > -				  0x01000000 0 0x00000000
> > -				  0x01000000 0 0x00000000
> > -				  0 0x00010000>;
> > -		};
> > -	};
> > -
> > -};
> > -
> > -/include/ "fsl/b4si-post.dtsi"
> > diff --git a/arch/powerpc/boot/dts/b4qds.dtsi  
> b/arch/powerpc/boot/dts/b4qds.dtsi
> > new file mode 100644
> > index 0000000..e6d2f8f
> > --- /dev/null
> > +++ b/arch/powerpc/boot/dts/b4qds.dtsi
> > @@ -0,0 +1,169 @@
> > +/*
> > + * B4420DS Device Tree Source
> > + *
> > + * Copyright 2012 Freescale Semiconductor, Inc.
> > + *
> > + * Redistribution and use in source and binary forms, with or  
> without
> > + * modification, are permitted provided that the following  
> conditions are met:
> > + *     * Redistributions of source code must retain the above  
> copyright
> > + *       notice, this list of conditions and the following  
> disclaimer.
> > + *     * Redistributions in binary form must reproduce the above  
> copyright
> > + *       notice, this list of conditions and the following  
> disclaimer in the
> > + *       documentation and/or other materials provided with the  
> distribution.
> > + *     * Neither the name of Freescale Semiconductor nor the
> > + *       names of its contributors may be used to endorse or  
> promote products
> > + *       derived from this software without specific prior written  
> permission.
> > + *
> > + *
> > + * ALTERNATIVELY, this software may be distributed under the terms  
> of the
> > + * GNU General Public License ("GPL") as published by the Free  
> Software
> > + * Foundation, either version 2 of that License or (at your  
> option) any
> > + * later version.
> > + *
> > + * This software is provided by Freescale Semiconductor "as is"  
> and any
> > + * express or implied warranties, including, but not limited to,  
> the implied
> > + * warranties of merchantability and fitness for a particular  
> purpose are
> > + * disclaimed. In no event shall Freescale Semiconductor be liable  
> for any
> > + * direct, indirect, incidental, special, exemplary, or  
> consequential damages
> > + * (including, but not limited to, procurement of substitute goods  
> or services;
> > + * loss of use, data, or profits; or business interruption)  
> however caused and
> > + * on any theory of liability, whether in contract, strict  
> liability, or tort
> > + * (including negligence or otherwise) arising in any way out of  
> the use of
> > + * this software, even if advised of the possibility of such  
> damage.
> > + */
> > +
> > +/ {
> > +	model = "fsl,B4QDS";
> > +	compatible = "fsl,B4QDS";
> > +	#address-cells = <2>;
> > +	#size-cells = <2>;
> > +	interrupt-parent = <&mpic>;
> > +
> > +	ifc: localbus@ffe124000 {
> > +		reg = <0xf 0xfe124000 0 0x2000>;
> > +		ranges = <0 0 0xf 0xe8000000 0x08000000
> > +			  2 0 0xf 0xff800000 0x00010000
> > +			  3 0 0xf 0xffdf0000 0x00008000>;
> > +
> > +		nor@0,0 {
> > +			#address-cells = <1>;
> > +			#size-cells = <1>;
> > +			compatible = "cfi-flash";
> > +			reg = <0x0 0x0 0x8000000>;
> > +			bank-width = <2>;
> > +			device-width = <1>;
> > +		};
> > +
> > +		nand@2,0 {
> > +			#address-cells = <1>;
> > +			#size-cells = <1>;
> > +			compatible = "fsl,ifc-nand";
> > +			reg = <0x2 0x0 0x10000>;
> > +
> > +			partition@0 {
> > +				/* This location must not be altered  */
> > +				/* 1MB for u-boot Bootloader Image */
> > +				reg = <0x0 0x00100000>;
> > +				label = "NAND U-Boot Image";
> > +				read-only;
> > +			};
> > +
> > +			partition@100000 {
> > +				/* 1MB for DTB Image */
> > +				reg = <0x00100000 0x00100000>;
> > +				label = "NAND DTB Image";
> > +			};
> > +
> > +			partition@200000 {
> > +				/* 10MB for Linux Kernel Image */
> > +				reg = <0x00200000 0x00A00000>;
> > +				label = "NAND Linux Kernel Image";
> > +			};
> > +
> > +			partition@c00000 {
> > +				/* 500MB for Root file System Image */
> > +				reg = <0x00c00000 0x1F400000>;
> > +				label = "NAND RFS Image";
> > +			};
> > +		};
> > +
> > +		board-control@3,0 {
> > +			compatible = "fsl,b4qds-fpga", "fsl,fpga-qixis";
> > +			reg = <3 0 0x300>;
> > +		};
> > +	};
> > +
> > +	memory {
> > +		device_type = "memory";
> > +	};
> > +
> > +	dcsr: dcsr@f00000000 {
> > +		ranges = <0x00000000 0xf 0x00000000 0x01052000>;
> > +	};
> > +
> > +	soc: soc@ffe000000 {
> > +		ranges = <0x00000000 0xf 0xfe000000 0x1000000>;
> > +		reg = <0xf 0xfe000000 0 0x00001000>;
> > +		spi@110000 {
> > +			flash@0 {
> > +				#address-cells = <1>;
> > +				#size-cells = <1>;
> > +				compatible = "sst,sst25wf040";
> > +				reg = <0>;
> > +				spi-max-frequency = <40000000>; /*  
> input clock */
> > +			};
> > +		};
> > +
> > +		sdhc@114000 {
> > +			/*Disabled as there is no sdhc connector on  
> B4420QDS board*/
> > +			status = "disabled";
> > +		};
> > +
> > +		i2c@118000 {
> > +			eeprom@50 {
> > +				compatible = "at24,24c64";
> > +				reg = <0x50>;
> > +			};
> > +			eeprom@51 {
> > +				compatible = "at24,24c256";
> > +				reg = <0x51>;
> > +			};
> > +			eeprom@53 {
> > +				compatible = "at24,24c256";
> > +				reg = <0x53>;
> > +			};
> > +			eeprom@57 {
> > +				compatible = "at24,24c256";
> > +				reg = <0x57>;
> > +			};
> > +			rtc@68 {
> > +				compatible = "dallas,ds3232";
> > +				reg = <0x68>;
> > +			};
> > +		};
> > +
> > +		usb@210000 {
> > +			dr_mode = "host";
> > +			phy_type = "ulpi";
> > +		};
> > +
> > +	};
> > +
> > +	pci0: pcie@ffe200000 {
> > +		reg = <0xf 0xfe200000 0 0x10000>;
> > +		ranges = <0x02000000 0 0xe0000000 0xc 0x00000000 0x0  
> 0x20000000
> > +			  0x01000000 0 0x00000000 0xf 0xf8000000 0x0  
> 0x00010000>;
> > +		pcie@0 {
> > +			ranges = <0x02000000 0 0xe0000000
> > +				  0x02000000 0 0xe0000000
> > +				  0 0x20000000
> > +
> > +				  0x01000000 0 0x00000000
> > +				  0x01000000 0 0x00000000
> > +				  0 0x00010000>;
> > +		};
> > +	};
> > +
> > +};
> > +
> > +/include/ "fsl/b4si-post.dtsi"
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
> 
> 


