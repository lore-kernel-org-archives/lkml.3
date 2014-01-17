Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaAQR1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:27:24 -0500
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:50001
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbaAQR1W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:27:22 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh1432I4015I14ffIzz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h906i1155h)
Date: Fri, 17 Jan 2014 09:27:15 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
References: <20140117143035.fa787a8203afaa83c64009bb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140117143035.fa787a8203afaa83c64009bb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <9ebf3c00-ac91-41bd-8fd0-24dc09e61a05@DB9EHSMHS001.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Jan 17, 2014 at 02:30:35PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> drivers/clocksource/cadence_ttc_timer.c between commit c1dcc927dae0
> ("clocksource: cadence_ttc: Fix mutex taken inside interrupt context")
> from Linus' tree and commit dfded00902d7 ("clocksource:
> cadence_ttc_timer: Switch to sched_clock_register()") from the tip tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).

The fix is correct.

	Thanks,
	Sören


