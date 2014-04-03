Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaDCSzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:55:05 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:18690 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275AbaDCSyr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:54:47 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z579ehz98dI9371Ic89bh936eI1432Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chz8dhz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
Date: Thu, 3 Apr 2014 11:54:30 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Harini Katakam <harinikatakamlinux@gmail.com>
CC: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Punnaiah Choudary <kpc528@gmail.com>,
        <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH 1/2] devicetree: Add devicetree bindings documentation
 for Zynq Quad SPI
References: <ee057d8c-50d9-4d4b-ac86-d7c5fc44b1b0@TX2EHSMHS034.ehs.local>
 <46a3a23e-786e-4acf-aa42-c3808b1a46d3@CH1EHSMHS028.ehs.local>
 <CAFcVECLoB8BR0PVfV=1EVQub8weOOYustg-1DqOevaihCT3JqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAFcVECLoB8BR0PVfV=1EVQub8weOOYustg-1DqOevaihCT3JqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <be8aa6d9-c9a3-4ea8-85fe-d5600e3ff749@TX2EHSMHS019.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 12:15AM +0530, Harini Katakam wrote:
> Hi Soren
> 
> On Thu, Apr 3, 2014 at 11:20 PM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> > Hi Punnaiah,
> >
> > On Thu, 2014-04-03 at 10:33PM +0530, Punnaiah Choudary Kalluri wrote:
> >> Add bindings documentation for Zynq Quad SPI driver.
> >>
> >> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
> >> ---
> >>  .../devicetree/bindings/spi/spi-zynq-qspi.txt      |   26 ++++++++++++++++++++
> >>  1 file changed, 26 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt b/Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt
> >> new file mode 100644
> >> index 0000000..88e00f8
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt
> >> @@ -0,0 +1,26 @@
> >> +Xilinx Zynq QSPI controller Device Tree Bindings
> >> +-------------------------------------------------
> >> +
> >> +Required properties:
> >> +- compatible         : Should be "xlnx,zynq-qspi-1.0".
> >> +- reg                        : Physical base address and size of QSPI registers map.
> >> +- interrupts         : Property with a value describing the interrupt
> >> +                       number.
> >> +- interrupt-parent   : Must be core interrupt controller
> >> +- clock-names                : List of input clock names - "ref_clk", "aper_clk"
> >> +                       (See clock bindings for details).
> >> +- clocks             : Clock phandles (see clock bindings for details).
> >> +
> >> +Optional properties:
> >> +- num-cs             : Number of chip selects used.
> >> +
> >> +Example:
> >> +     qspi@e000d000 {
> >> +             compatible = "xlnx,zynq-qspi-1.0";
> >> +             clock-names = "ref_clk", "aper_clk";
> >
> > These seem to be the SOC names of the clocks. Doesn't have the IP its
> > own naming for these clock inputs?
> >
> 
> The IP design spec uses the name ref_clk.
> There is no particular clock name used for for APB clock.
> So I think aper_clk is a valid name to use.

aper is a Zynq-ism, IMHO. I think 'pclk', 'apbclk' or
something like that is more appropriate.

	Sören


