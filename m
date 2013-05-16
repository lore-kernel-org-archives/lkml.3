Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3EPSzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:55:51 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:10103
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582Ab3EPSzt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:55:49 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ic89bh1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh906i1155h)
Date: Thu, 16 May 2013 11:55:45 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mark Brown <broonie@kernel.org>
CC: Philip Balister <philip@balister.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
References: <519112F9.2010102@gmail.com>
 <7c5e7537-6ed5-4622-a7a9-bf46820ef695@VA3EHSMHS033.ehs.local>
 <519124D3.2040403@gmail.com>
 <af51c63e-7ff1-4e73-9305-08309217ab38@TX2EHSMHS037.ehs.local>
 <20130514164611.10068.46384@quantum>
 <51927DEB.7090001@balister.org>
 <20130515044604.GA24524@sirena.org.uk>
 <51946082.1000606@codeaurora.org>
 <5194F0C0.9020609@balister.org>
 <20130516172605.GB1627@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130516172605.GB1627@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <1b69c011-cab5-4fde-a61d-7e2536208920@CH1EHSMHS003.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 06:26:05PM +0100, Mark Brown wrote:
> On Thu, May 16, 2013 at 10:44:16AM -0400, Philip Balister wrote:
> > On 05/16/2013 12:28 AM, Saravana Kannan wrote:
> 
> > > Agreed. I was about to reply with exactly the same point. I haven't done
> > > any UIO coding, but that device file will eventually have to be opened.
> > > Turn on the clocks in the open and turn them off at close.
> 
> > > Rate to request can be a DT property.
> 
> > But you are assuming each device implemented in the fpga uses one clock.
> > This assumption is clearly not valid since devices will ahve to share
> > clocks.
> 
> The binding should obviously be defined as a set of clocks rather than a
> single clock - something like how we specify regulators on PMICs
> probably makes sense.  Each clock can have its own properties.
For a device driver as clock consumer, the bindings etc. are well
defined. Just add the 'clocks' and 'clock-names' props and use the CCF.

	Sören


