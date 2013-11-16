Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3KPAI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:08:27 -0500
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:7171
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753958Ab3KPAIT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:08:19 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z579ehz98dIc89bh1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2149h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h906i1155h192ch)
Date: Fri, 15 Nov 2013 16:08:13 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 2/4] clocksource: cadence_ttc_timer: Switch to
 sched_clock_register()
References: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org>
 <1384559315-18699-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1384559315-18699-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <b427a192-854c-4425-b497-ca801d3df5e8@CO1EHSMHS015.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 03:48:33PM -0800, Stephen Boyd wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface.
> 
> Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Cc: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Tested-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Small enough of a change to quickly test. Works fine.

	Thanks,
	Sören


