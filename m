Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaDGPjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:39:49 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:4505
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946AbaDGPjq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:39:46 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ic89bh936eI1432Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz8275ch1de098h17326ah8275bh1de097h186068hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
Date: Mon, 7 Apr 2014 08:39:34 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Looijmans <mike.looijmans@topic.nl>
CC: <monstr@monstr.eu>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v2 2/5] ARM: zynq: dt: Convert to preprocessor includes
References: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com>
 <1396653256-28397-3-git-send-email-soren.brinkmann@xilinx.com>
 <53423E75.3020008@monstr.eu>
 <53429754.8080105@topic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <53429754.8080105@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <8db0b480-2c27-4f97-8712-e16fd39d4159@CH1EHSMHS038.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 02:17PM +0200, Mike Looijmans wrote:
> On 04/07/2014 07:58 AM, Michal Simek wrote:
> >Hi Soren,
> >
> >On 04/05/2014 01:14 AM, Soren Brinkmann wrote:
> >>Convert all Zynq DT files to the dtc preprocessor include syntax.
> >>This allows to include header files in the devicetrees like other
> >>SoC-types already do.
> >>
> >>Inspired-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> >>(http://www.spinics.net/lists/arm-kernel/msg319832.html)
> >>
> >>Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >
> >These 4 patches needs more wider discussion if this is helpful or
> >not. Currently I can't see any value in it because everything
> >is just generated and fixed. I think I had the same discussion
> >with Laurent some weeks ago regarding this.
> 
> I would be kinda neutral here. I'd consider it helpful, it improves
> readability (regardless of whether they are generated or hand
> crafted). That's convenient for things like interrupt sensitivity, I
> can't remember whether 4 is level or edge type. On the other hand,
> the clock indices are just as much magic numbers as the memory
> addresses. If I suspect an error in that area, I'd start by lokking
> in /sys/kernel/debug/clk but wouldn't start in the DT.

I agree. Readability is better this way. And whether our generator spits
out magic numbers of these symbolic names should not be a big
difference, is it?

	Sören


