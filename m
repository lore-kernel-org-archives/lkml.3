Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbaDKTlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 15:41:20 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:44812
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbaDKTlQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 15:41:16 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh936eI1432I4015Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
Date: Fri, 11 Apr 2014 12:41:02 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <monstr@monstr.eu>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: Re: [PATCH v2 1/5] ARM: zynq: DT: Add 'clock-latency' property
References: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com>
 <1396653256-28397-2-git-send-email-soren.brinkmann@xilinx.com>
 <53423BB6.7010508@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <53423BB6.7010508@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <34776df5-5255-4d58-a5ab-83f2017e16fc@AM1EHSMHS018.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 07:46AM +0200, Michal Simek wrote:
> On 04/05/2014 01:14 AM, Soren Brinkmann wrote:
> > Specify the 'clock-latency' property to avoid certain cpufreq governors
> > from refusing to work with the following error:
> >   ondemand governor failed, too long transition latency of HW, fallback to performance governor
> > 
> > Reported-by: Mike Looijmans <mike.looijmans@topic.nl>
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > Tested-by: Mike Looijmans <mike.looijmans@topic.nl>
> > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > ---
> > This is a fix from our vendor tree
> > 
> > Changes in v2:
> >  - This patch has been added
> > 
> > ---
> >  arch/arm/boot/dts/zynq-7000.dtsi | 1 +
> >  1 file changed, 1 insertion(+)
> 
> Applied to zynq-dt.

Actually, this should probably go in as fix into the current (3.15)
release cycle.

	Thanks,
	Sören


