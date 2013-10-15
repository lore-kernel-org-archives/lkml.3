Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab3JOPen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:34:43 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:2446 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab3JOPel convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:34:41 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z551bizbb2dI98dI9371Ic89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Tue, 15 Oct 2013 08:34:34 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 5/5] net: macb: Adjust tx_clk when link speed changes
References: <1381795140-10792-1-git-send-email-soren.brinkmann@xilinx.com>
 <1381795140-10792-6-git-send-email-soren.brinkmann@xilinx.com>
 <525CF4AD.1070304@atmel.com>
 <dd225b7c-ee2a-4747-9a50-55b77a114376@DB9EHSMHS006.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <dd225b7c-ee2a-4747-9a50-55b77a114376@DB9EHSMHS006.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <bc7eae62-d683-493e-a22a-515e70a0c82b@CO9EHSMHS001.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:58:09AM +0200, Michal Simek wrote:
> On 10/15/2013 09:54 AM, Nicolas Ferre wrote:
> > On 15/10/2013 01:59, Soren Brinkmann :
> >> Adjust the ethernet clock according to the negotiated link speed.
> >>
> >> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > 
> > I will need more time to study this one.
> > 
> > Moreover, I will have to add the "tx_clk" to every user of this driver before switchin to the addition of this clock.
> 
> As I am reading this patch, Soren just protected this
> case that if this clk is not specified then it is not used.
That is how I sketched things in this patch. But as I said, I'm not
fully convinced this approach fits all or is the best. So, if anybody
has a better approach, let us know.

	Sören


