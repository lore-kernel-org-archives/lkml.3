Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3KAJqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:46:01 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:22256
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420Ab3KAJpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:45:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275dh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1155h)
Date: Fri, 1 Nov 2013 17:33:27 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Vinod Koul <vinod.koul@intel.com>, <timur@tabi.org>, <broonie@kernel.org>,
        <s.hauer@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <alsa-devel@alsa-project.org>,
        <rob.herring@calxeda.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCH v4 0/4] Add dual-fifo mode support of i.MX ssi
Message-ID: <20131101093326.GE28401@MrMyself>
References: <cover.1383226444.git.b42378@freescale.com>
 <20131101091156.GC10324@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131101091156.GC10324@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 05:11:58PM +0800, Shawn Guo wrote:
> Nicolin,
> 
> The dmaengine maintainer Vinod Koul should be copied on the series.
> (Just added).
>

Ah, I was careless last night when I sent these patches. My VPN connection
was pretty laggy :( Please forgive me, Vinod.

Thank Shawn for adding for me. Much obliged.

> On Thu, Oct 31, 2013 at 09:44:12PM +0800, Nicolin Chen wrote:
> > Nicolin Chen (4):
> >   dma: imx-sdma: Add sdma firmware version 2 support
> >   dma: imx-sdma: Add new dma type for ssi dual fifo script
> >   ASoC: fsl_ssi: Add dual fifo mode support
> >   ARM: dts: imx: use dual-fifo sdma script for ssi
> 
> Vinod,
> 
> To keep git bisect, the series has to be merged through single tree.
> Since Mark has ACK-ed patch #3, I think it's easier to merge the series
> through your tree, so for patch #4:
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>


