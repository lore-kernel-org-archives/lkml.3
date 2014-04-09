Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbaDIISB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 04:18:01 -0400
Received: from tx2ehsobe008.messaging.microsoft.com ([65.55.88.32]:46770 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758037AbaDIIR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 04:17:57 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 04:17:57 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Wed, 9 Apr 2014 15:51:55 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <alsa-devel@alsa-project.org>,
        <timur@tabi.org>, <Li.Xiubo@freescale.com>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <rob@landley.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: Re: [PATCH v3 2/2] ARM: dts: Append clock bindings for sai2 on VF610
 platform
Message-ID: <20140409075154.GA12559@MrMyself>
References: <cover.1396605772.git.Guangyu.Chen@freescale.com>
 <08ba57a2fdce1a404a6bcb61e21e25509fcd6b30.1396605772.git.Guangyu.Chen@freescale.com>
 <20140409075812.GC28420@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140409075812.GC28420@dragon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 03:58:15PM +0800, Shawn Guo wrote:
> On Fri, Apr 04, 2014 at 06:08:13PM +0800, Nicolin Chen wrote:
> > Since we added fours clock to the DT binding, we should update the current
> > SAI dts/dtsi so as not to break their functions.
> 
> If so, shouldn't the change be in the same patch as driver change?

Okay..I'd like to merge them into one patch.

Thank you,
Nicolin

> 
> Shawn
> 
> > 
> > Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> > Tested-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  arch/arm/boot/dts/vf610.dtsi | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> > index d31ce1b..9fd0007 100644
> > --- a/arch/arm/boot/dts/vf610.dtsi
> > +++ b/arch/arm/boot/dts/vf610.dtsi
> > @@ -139,8 +139,10 @@
> >  				compatible = "fsl,vf610-sai";
> >  				reg = <0x40031000 0x1000>;
> >  				interrupts = <0 86 0x04>;
> > -				clocks = <&clks VF610_CLK_SAI2>;
> > -				clock-names = "sai";
> > +				clocks = <&clks VF610_CLK_SAI2>,
> > +				       <&clks VF610_CLK_SAI2>,
> > +				       <&clks 0>, <&clks 0>;
> > +				clock-names = "bus", "mclk1", "mclk2", "mclk3";
> >  				status = "disabled";
> >  			};
> >  
> > -- 
> > 1.8.4
> > 
> > 
> 

