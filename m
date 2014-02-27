Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaB0Rw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:52:27 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:38623
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720AbaB0Rw0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:52:26 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dIc89bh936eI1432I4015Idf9Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh906i1155h)
Date: Thu, 27 Feb 2014 09:52:17 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/4] ARM: zynq: cpufreq support
References: <1392851684-29950-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1392851684-29950-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <3402bb7c-3dec-403a-9356-65af803e1b0a@AM1EHSMHS017.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel, Michal,

On Wed, 2014-02-19 at 03:14PM -0800, Soren Brinkmann wrote:
> Hi,
> 
> another iteration of this series. The patches are the same as in v3, but
> the series shrank a bit. I rebased this series on tip/timers/core, hence
> the two patches for the clockevent core fell out, since Thomas already
> applied those.
> Additionally I removed the patch 'clocksource/cadence_ttc: Use only one
> counter'. Thomas brought up some questions regarding that patch which
> need to be investigated. Since it is not required for the rest of this
> series, I just dropped it for now.
> 
> 	Thanks,
> 	Sören
> 
> Soren Brinkmann (4):
>   clocksource/cadence_ttc: Call clockevents_update_freq() with IRQs
>     enabled
>   clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
>   arm: zynq: Don't use arm_global_timer with cpufreq
>   arm: zynq: Add support for cpufreq

Any comments? I think most of these should be pretty straight forward
and it would be nice to get some ACKs - or tell me what's wrong. :)
'clocksource/cadence_ttc: Overhaul clocksource frequency adjustment'
might deserve a more thorough review.

	Thanks,
	Sören


