Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3F0Vwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 17:52:41 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:25373
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab3F0Vwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 17:52:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Ic8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Thu, 27 Jun 2013 16:52:32 -0500
From: Scott Wood <scottwood@freescale.com>
To: Benjamin Collins <ben.c@servergy.com>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: sgy-cts-1000: New DTS file for Servergy CTS-1000 systems
Message-ID: <20130627215232.GA561@home.buserror.net>
References: <E1UJ1fR-0004i4-H8@swissweb.swissdisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <E1UJ1fR-0004i4-H8@swissweb.swissdisk.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 01:14:22AM -0400, Benjamin Collins wrote:
> This isn't specifically needed in order to build the kernel. It's
> stored in flash with firmware. However, keep it in the kernel for
> reference (and to have an example for fsl_dpa device tree usage).
> 
> Signed-off-by: Ben Collins <ben.c@servergy.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> 
> ---
> arch/powerpc/boot/dts/sgy-cts-1000.dts | 1570 ++++++++++++++++++++++++++++++++
>  1 file changed, 1570 insertions(+)
>  create mode 100644 arch/powerpc/boot/dts/sgy-cts-1000.dts

Applying: sgy-cts-1000: New DTS file for Servergy CTS-1000 systems
/home/scott/fsl/git/linux/upstream/.git/rebase-apply/patch:201: space
/before tab in indent.
  				      84 2 0 0
/home/scott/fsl/git/linux/upstream/.git/rebase-apply/patch:873: trailing
whitespace.
				/* 
warning: 2 lines add whitespace errors.

> diff --git a/arch/powerpc/boot/dts/sgy-cts-1000.dts b/arch/powerpc/boot/dts/sgy-cts-1000.dts
> new file mode 100644
> index 0000000..1efa01a
> --- /dev/null
> +++ b/arch/powerpc/boot/dts/sgy-cts-1000.dts
> @@ -0,0 +1,1570 @@
> +/*
> + * Servergy CTS-1000 Device Tree Source
> + *
> + * Copyright 2009-2011 Freescale Semiconductor Inc.
> + * Copyright 2011-2013 Servergy, Inc.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are met:
> + *     * Redistributions of source code must retain the above copyright
> + *       notice, this list of conditions and the following disclaimer.
> + *     * Redistributions in binary form must reproduce the above copyright
> + *       notice, this list of conditions and the following disclaimer in the
> + *       documentation and/or other materials provided with the distribution.
> + *     * Neither the name of Freescale Semiconductor nor the
> + *       names of its contributors may be used to endorse or promote products
> + *       derived from this software without specific prior written permission.
> + *
> + *
> + * ALTERNATIVELY, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") as published by the Free Software
> + * Foundation, either version 2 of that License or (at your option) any
> + * later version.
> + *
> + * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
> + * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
> + * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
> + * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
> + * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
> + * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +/dts-v1/;
> +
> +/ {
> +	model = "sgy,cts-1000";
> +	compatible = "fsl,P4080DS";

This isn't a P4080DS.  Your board needs its own toplevel compatible.

> +		fman0 = &fman0;
> +		fman0_oh0 = &fman0_oh0;
> +		fman0_oh1 = &fman0_oh1;
> +		fman0_oh2 = &fman0_oh2;
> +		fman0_oh3 = &fman0_oh3;
> +		fman0_oh4 = &fman0_oh4;
> +		fman0_oh5 = &fman0_oh5;
> +		fman0_oh6 = &fman0_oh6;
> +		fman0_rx0 = &fman0_rx0;
> +		fman0_rx1 = &fman0_rx1;
> +		fman0_rx2 = &fman0_rx2;
> +		fman0_rx3 = &fman0_rx3;
> +		fman0_rx4 = &fman0_rx4;
> +
> +		fman1 = &fman1;
> +		fman1_oh0 = &fman1_oh0;
> +		fman1_oh1 = &fman1_oh1;
> +		fman1_oh2 = &fman1_oh2;
> +		fman1_oh3 = &fman1_oh3;
> +		fman1_oh4 = &fman1_oh4;
> +		fman1_oh5 = &fman1_oh5;
> +		fman1_oh6 = &fman1_oh6;
> +		fman1_rx0 = &fman1_rx0;
> +		fman1_rx1 = &fman1_rx1;
> +		fman1_rx2 = &fman1_rx2;
> +		fman1_rx3 = &fman1_rx3;
> +		fman1_rx4 = &fman1_rx4;
> +	};

We need a proper device tree binding for this stuff first.

> +	dcsr: dcsr@f00000000 {
> +		ranges = <0x00000000 0xf 0x00000000 0x01008000>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		compatible = "fsl,dcsr", "simple-bus";

Please use fsl/p4080si-post.dtsi rather than duplicating all of this.

You appear to have based this on an old SDK kernel, rather than the
current mainline kernel.

> +			hwmon@4c {
> +				compatible = "adt,adt7461";
> +				reg = <0x4c>;
> +				/* 
> +				 * Enabling this causes a flood of interrupts
> +				 * on the ds3232 device (and since it never
> +				 * gets ACK'd, it consumes 100% of a CPU).
> +				 * -- BenC
> +				interrupts = <1 10 0 0
> +					      1 11 0 0>;
> +				 */

"1 10 0 0" and "1 11 0 0" don't look like valid MPIC interrupt specifiers
to me, though.  Maybe that's the problem?  Is it supposed to be:

	<10 1 0 0 11 1 0 0>

?

> +	localbus@ffe124000 {
> +		compatible = "fsl,p4080-elbc", "fsl,elbc", "simple-bus";
> +		reg = <0xf 0xfe124000 0 0x1000>;
> +		interrupts = <25 2 0 0>;
> +		#address-cells = <2>;
> +		#size-cells = <1>;
> +
> +		ranges = <0 0 0xf 0xe8000000 0x08000000>;
> +
> +		/* 256M Flash device */
> +		flash@0,0 {
> +			compatible = "cfi-flash";
> +			reg = <0 0 0x08000000>;
> +			bank-width = <2>;
> +			device-width = <2>;
> +			#address-cells = <0x1>;
> +			#size-cells = <0x1>;
> +
> +			/* 16M for kernel */
> +			partition@0 {
> +				label = "sgyboot-kernel";
> +				reg = <0x00000000 0x01000000>;
> +			};
> +			/* 64M for root fs */
> +			partition@1 {
> +				label = "sgyboot-initrd";
> +				reg = <0x01000000 0x04000000>;
> +			};
> +			/* 256K for FMan microcode */
> +			partition@2 {
> +				label = "fsl-fman-ucode";
> +				reg = <0x05000000 0x00040000>;
> +			};
> +			/* 256K for Device-tree */
> +			partition@3 {
> +				label = "device-tree";
> +				reg = <0x05040000 0x00040000>;
> +			};
> +			/* 128K for u-Boot environment */
> +			partition@4 {
> +				label = "u-boot-env";
> +				reg = <0x05080000 0x00020000>;
> +			};
> +			/* 128K Unused */
> +
> +			/* 1Meg for splash screen in u-boot's UDL driver */
> +			partition@6 {
> +				label = "udl-splash";
> +				reg = <0x050c0000 0x00100000>;
> +			};
> +
> +			/* ~44Megs Unused */
> +
> +			/* 2.5M for u-Boot */
> +			partition@5 {
> +				label = "u-boot";
> +				reg = <0x07D80000 0x00280000>;
> +			};
> +
> +			/* The whole flash area */
> +			partition@20 {
> +				label = "whole";
> +				reg = <0x00000000 0x08000000>;
> +			};

Are overlapping partitions allowed?

Plus, unit addresses are supposed to match reg.

> +	pci0: pcie@ffe200000 {
> +		compatible = "fsl,p4080-pcie";
> +		device_type = "pci";
> +		#size-cells = <2>;
> +		#address-cells = <3>;
> +		reg = <0xf 0xfe200000 0 0x1000>;
> +		bus-range = <0x0 0xff>;
> +		ranges = <0x02000000 0 0xe0000000 0xc 0x00000000 0x0 0x20000000
> +			  0x01000000 0 0x00000000 0xf 0xf8000000 0x0 0x00010000>;
> +		clock-frequency = <0x1fca055>;
> +		fsl,msi = <&msi0>;
> +		interrupts = <16 2 1 15>;

Where does "fsl,msi" come from?

-Scott

