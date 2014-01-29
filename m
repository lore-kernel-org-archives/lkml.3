Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaA2Br6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 20:47:58 -0500
Received: from [216.32.181.182] ([216.32.181.182]:36109 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751217AbaA2Br5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 20:47:57 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(z579ehzc89bhda00hdc73hzz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hz70kz8275dh1de097h186068hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h906i1155h)
Date: Tue, 28 Jan 2014 17:47:28 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>, Yinghai Lu <yinghai@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Biscted to 'memblock, nobootmem: add
 memblock_virt_alloc_low()'
References: <35c4753f-bcb5-46df-b273-e5b39db163f0@CO9EHSMHS018.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <35c4753f-bcb5-46df-b273-e5b39db163f0@CO9EHSMHS018.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <019582d5-f632-467b-8c67-60e66ef5ab73@CH1EHSMHS011.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Never mind. I just saw, Zynq is not the only affected ARM platform and
the issue is already being discussed on the list:
https://lkml.org/lkml/2014/1/28/52

	Sören


