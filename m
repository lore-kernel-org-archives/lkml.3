Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab3FLSlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:41:51 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:30079
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612Ab3FLSlu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:41:50 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2013 14:41:49 EDT
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Wed, 12 Jun 2013 11:26:34 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 3/3] arm: dt: zynq: Add support for the zed platform
References: <1371055268-32337-1-git-send-email-soren.brinkmann@xilinx.com>
 <1371055268-32337-4-git-send-email-soren.brinkmann@xilinx.com>
 <20130612182345.GA1656@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130612182345.GA1656@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <2433e1d1-7d2e-4b23-a76e-2085e3aef1a6@DB9EHSMHS010.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 08:23:45PM +0200, Steffen Trumtrar wrote:
> On Wed, Jun 12, 2013 at 09:41:08AM -0700, Soren Brinkmann wrote:
> > Add a DT fragment for the Zed Zynq platform and a corresponding
> > target to the Makefile
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > I used the 'xlnx,...' compat strings since it seems this is what is
> > used in the Xilinx and Digilent vendor trees.
> > 
> > +/include/ "zynq-7000.dtsi"
> > +
> > +/ {
> > +	model = "Zynq Zed Development Board";
> > +	compatible = "xlnx,zynq-zed", "xlnx,zynq-7000";
> > +
> > +	memory {
> > +		device_type = "memory";
> > +		reg = <0 0x20000000>;
> > +	};
> > +
> > +	chosen {
> > +		bootargs = "console=ttyPS1,115200 earlyprintk";
> > +	};
> > +
> > +};
> 
> Hi!
> 
> This looks a little bit to basic. No?! Not even an UART?
The UART is imported from the common zynq-7000.dtsi.

> The compatible should include digilent or avnet. Digilent only sells to academic
> customers, Avnet doesn't.
I don't care at all. So, who makes the decision which one is the correct
one? Actually we could even drop the zed specific one completely and go
with 'xlnx,zynq-7000' only.

	Sören


