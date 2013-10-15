Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab3JOH6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:58:23 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:30429
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757903Ab3JOH6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:58:18 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizbb2dI98dI9371I1454I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2fh95h839h947hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh19b6n1155h192ch)
Date: Tue, 15 Oct 2013 09:58:09 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>, <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC 5/5] net: macb: Adjust tx_clk when link speed changes
References: <1381795140-10792-1-git-send-email-soren.brinkmann@xilinx.com> <1381795140-10792-6-git-send-email-soren.brinkmann@xilinx.com> <525CF4AD.1070304@atmel.com>
In-Reply-To: <525CF4AD.1070304@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <dd225b7c-ee2a-4747-9a50-55b77a114376@DB9EHSMHS006.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 09:54 AM, Nicolas Ferre wrote:
> On 15/10/2013 01:59, Soren Brinkmann :
>> Adjust the ethernet clock according to the negotiated link speed.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> 
> I will need more time to study this one.
> 
> Moreover, I will have to add the "tx_clk" to every user of this driver before switchin to the addition of this clock.

As I am reading this patch, Soren just protected this
case that if this clk is not specified then it is not used.

But anyway feel free to take more time to study it.

If there is device-tree binding then it should be extend
by this optional value.

Thanks,
Michal


