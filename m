Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab3GPPv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:51:29 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:34728
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932590Ab3GPPv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:51:27 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ida00h1432Idc73hzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Tue, 16 Jul 2013 08:51:13 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: <monstr@monstr.eu>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Baruch Siach <baruch@tkos.co.il>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 2/2] clocksource/cadence_ttc: Reuse clocksource as
 sched_clock
References: <1373302298-27957-1-git-send-email-soren.brinkmann@xilinx.com>
 <1373302298-27957-3-git-send-email-soren.brinkmann@xilinx.com>
 <51DFF1AA.8080407@monstr.eu>
 <51E56799.2090601@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <51E56799.2090601@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <9616f33f-9b1b-4f0c-9b2c-51806fc1c4c6@CO1EHSMHS007.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 05:32:41PM +0200, Daniel Lezcano wrote:
> On 07/12/2013 02:08 PM, Michal Simek wrote:
> > Acked-by: Michal Simek <monstr@monstr.eu>
> 
> Applied to my tree for 3.12
thanks


