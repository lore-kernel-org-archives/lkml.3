Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965959AbaDJKMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:12:38 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:52253
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965088AbaDJKM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:12:28 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(z579eh551bizbb2dI98dI9371I1432I4015Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzzz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h268bh26d3h2673i19b6n1155h)
Date: Thu, 10 Apr 2014 12:11:58 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Michal Simek <michal.simek@xilinx.com>, Michal Simek <monstr@monstr.eu>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        <dougthompson@xmission.com>, <linux-edac@vger.kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <sorenb@xilinx.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kpc528@gmail.com>,
        <kalluripunnaiahchoudary@gmail.com>, <punnaia@xilinx.com>
Subject: Re: [RFC PATCH v2] edac: synopsys: Added EDAC support for zynq ddr
 ecc controller
References: <1220b715-6fc2-42ed-8393-b9859fc0deb9@TX2EHSMHS021.ehs.local> <20140408204047.GQ30077@pd.tnic> <534633C0.9090905@monstr.eu> <20140410092144.GD29093@pd.tnic> <5e0042b6-f169-4025-8fd7-9d70c2ed0cf6@AM1EHSMHS012.ehs.local> <20140410100047.GG29093@pd.tnic> <20140410100542.GH29093@pd.tnic>
In-Reply-To: <20140410100542.GH29093@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <2508260c-5ae5-4ff5-97a9-248470c062af@CH1EHSMHS012.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 12:05 PM, Borislav Petkov wrote:
> On Thu, Apr 10, 2014 at 12:00:47PM +0200, Borislav Petkov wrote:
>> Then you'll have to check whether edac can even stomach more than one
>> drivers in parallel. TTBOMK, no one has ever done this so far... Yadda
>> yadda.
> 
> Alternatively, you could put together a single edac driver which
> contains both zynq and L2 functionality.

That's seems to more problematic because we just don't know what our
customers will do and what combinations they will use.

Thanks,
Michal


