Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaB1G0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:26:17 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:58500
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873AbaB1G0Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:26:16 -0500
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zzbb2dI98dI9371Ic89bh936eI1432I4015Idf9Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh19b6n1155h)
Date: Fri, 28 Feb 2014 07:26:03 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/4] ARM: zynq: cpufreq support
References: <1392851684-29950-1-git-send-email-soren.brinkmann@xilinx.com> <20140227175217.GW13293@xsjandreislx>
In-Reply-To: <20140227175217.GW13293@xsjandreislx>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
X-RCIS-Action: ALLOW
Message-ID: <2aebf1c5-f0d6-41a9-b6f7-c709ceecc9a1@AM1EHSMHS006.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 06:52 PM, Sören Brinkmann wrote:
> Hi Daniel, Michal,
> 
> On Wed, 2014-02-19 at 03:14PM -0800, Soren Brinkmann wrote:
>> Hi,
>>
>> another iteration of this series. The patches are the same as in v3, but
>> the series shrank a bit. I rebased this series on tip/timers/core, hence
>> the two patches for the clockevent core fell out, since Thomas already
>> applied those.
>> Additionally I removed the patch 'clocksource/cadence_ttc: Use only one
>> counter'. Thomas brought up some questions regarding that patch which
>> need to be investigated. Since it is not required for the rest of this
>> series, I just dropped it for now.
>>
>> 	Thanks,
>> 	Sören
>>
>> Soren Brinkmann (4):
>>   clocksource/cadence_ttc: Call clockevents_update_freq() with IRQs
>>     enabled
>>   clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
>>   arm: zynq: Don't use arm_global_timer with cpufreq
>>   arm: zynq: Add support for cpufreq
> 
> Any comments? I think most of these should be pretty straight forward
> and it would be nice to get some ACKs - or tell me what's wrong. :)
> 'clocksource/cadence_ttc: Overhaul clocksource frequency adjustment'
> might deserve a more thorough review.

No problem from my side.
Daniel?

Thanks,
Michal


