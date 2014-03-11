Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbaCKJid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:38:33 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:17754
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389AbaCKJia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:38:30 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzbb2dI98dI9371I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h947hc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h19b6n1155h)
Date: Tue, 11 Mar 2014 10:38:14 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Michal Simek <michal.simek@xilinx.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, <monstr@monstr.eu>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <robh+dt@kernel.org>,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        <grant.likely@linaro.org>, Kedareswara rao Appana <appanad@xilinx.com>,
        <wg@grandegger.com>
Subject: Re: [PATCH v5] can: xilinx CAN controller support.
References: <5254bfec-c6fd-4681-a34d-706d51e60fbb@VA3EHSMHS004.ehs.local> <531DD493.3030306@monstr.eu> <531DD5E7.7090406@pengutronix.de> <3245971.RIuVmbVL0Z@wuerfel> <1964213d-6bd9-49fa-805e-42e1e0630fd5@VA3EHSMHS029.ehs.local> <20140311044555.GA12373@localhost>
In-Reply-To: <20140311044555.GA12373@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <546dbc60-dd7b-4249-bab8-ad7e008b9aad@AM1EHSMHS001.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 05:45 AM, Fengguang Wu wrote:
>>> You probably want something like
>>>
>>> 	config CAN_XILINX
>>> 	tristate "Xilinx CAN"
>>> 	depends on ARCH_ZYNQ || MICROBLAZE || COMPILE_TEST
>>> 	depends on COMMON_CLK && HAS_MMIO  # whatever you need for other architectures
>>
>> Fengguang: Are you use COMPILE_TEST in zero day testing system?
> 
> Yeah, the randconfig build/boot tests should cover both COMPILE_TEST
> and !COMPILE_TEST cases.

But the point is that randconfig is really random it means it definitely can
cover but not there is no certainty that for that build, you are running,
has both option for all architectures enabled.
Or do I read it wrongly?

Thanks,
Michal


