Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3KVTbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:31:44 -0500
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:6926
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755495Ab3KVTbm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:31:42 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z551bizbb2dI98dIc89bh1431J1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2149h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h906i1155h)
Date: Fri, 22 Nov 2013 11:31:30 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC 5/5] net: macb: Adjust tx_clk when link speed changes
References: <1381795140-10792-1-git-send-email-soren.brinkmann@xilinx.com>
 <1381795140-10792-6-git-send-email-soren.brinkmann@xilinx.com>
 <525CF4AD.1070304@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <525CF4AD.1070304@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <0f0684eb-c3c1-4fbf-97da-1cd03f0a3a6f@DB8EHSMHS008.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Tue, Oct 15, 2013 at 09:54:21AM +0200, Nicolas Ferre wrote:
> On 15/10/2013 01:59, Soren Brinkmann :
> >Adjust the ethernet clock according to the negotiated link speed.
> >
> >Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> 
> I will need more time to study this one.
> 
> Moreover, I will have to add the "tx_clk" to every user of this
> driver before switchin to the addition of this clock.

I just wanted to follow up on this. Did you have a chance to look at
this closer?

	Thanks,
	Sören


