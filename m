Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422693AbaKNVOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:14:50 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38826 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754335AbaKNVOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:14:48 -0500
Date: Fri, 14 Nov 2014 22:14:44 +0100
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 11/13] ARM: dts: Berlin: enable USB on the BG2Q DMP
Message-ID: <20141114211444.GB8105@kwain>
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com>
 <1415978763-27345-12-git-send-email-antoine.tenart@free-electrons.com>
 <54664E2F.6070701@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54664E2F.6070701@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 14, 2014 at 09:47:11PM +0300, Sergei Shtylyov wrote:
> On 11/14/2014 06:26 PM, Antoine Tenart wrote:
> 
> >Enable the 2 available USB PHY and USB nodes on the Marvell Berlin BG2Q
> >DMP.
> 
> >Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> >---
> >  arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 53 ++++++++++++++++++++++++++++++
> >  1 file changed, 53 insertions(+)
> 
> >diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
> >index ea1f99b8eed6..f7c25580e122 100644
> >--- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
> >+++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
> [...]
> >@@ -21,6 +23,39 @@
> >  	choosen {
> >  		bootargs = "console=ttyS0,115200 earlyprintk";
> >  	};
> >+
> >+	regulators {
> >+		compatible = "simple-bus";
> >+		#address-cells = <1>;
> >+		#size-cells = <0>;
> >+
> >+		reg_usb0_vbus: regulator@0 {
> 
>    Erm, I'm not seeing the "reg" prop. The <unit-address> part of the name
> shouldn't be used without the "reg" prop.
> 
> [...]

Well, I respect the bindings described at:
Documentation/devicetree/bindings/regulator/fixed-regulator.txt

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
