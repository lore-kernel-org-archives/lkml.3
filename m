Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaBMHA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:00:27 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:55992
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbaBMHAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:00:25 -0500
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzbb2dI98dI9371I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2fh95h839h947hc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh19b6n1155h)
Date: Thu, 13 Feb 2014 08:00:10 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <michal.simek@xilinx.com>, <netdev@vger.kernel.org>, <sthokal@xilinx.com>,
        <devicetree@vger.kernel.org>, <monstr@monstr.eu>,
        <John.Linn@xilinx.com>, <anirudh@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/14] Xilinx axi ethernet patches
References: <cover.1392220536.git.michal.simek@xilinx.com> <20140212.191846.1464564509609498703.davem@davemloft.net>
In-Reply-To: <20140212.191846.1464564509609498703.davem@davemloft.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <3744167b-7f37-4a86-8569-2a17bd5d3845@CH1EHSMHS035.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 01:18 AM, David Miller wrote:
> From: Michal Simek <michal.simek@xilinx.com>
> Date: Wed, 12 Feb 2014 16:55:34 +0100
> 
>> I have exctracted patches which I have in our
>> xilinx git tree which are missing in the mainline.
>>
>> The first two patches fix compilation error and
>> warnings. Then 5 feature patches
>> and the rest is OF cleanup and with kernel-doc
>> and checkpatch problems.
> 
> You should not combine bug fix and feature patches.
> 
> Rather, you should submit bug fixes against the 'net' tree.  Then when
> those bug fixes get applied and propagate to the 'net-next' tree you
> can submit the feature patches and cleanups against the 'net-next'
> tree.

Ok. I will.

Thanks,
Michal


