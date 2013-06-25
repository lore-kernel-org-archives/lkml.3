Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3FYNn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:43:56 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:13655
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab3FYNny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:43:54 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 25 Jun 2013 21:44:21 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <john.stultz@linaro.org>,
        <tglx@linutronix.de>, Jingchang Lu <b35083@freescale.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 1/1] clocksource: vf_pit_timer: Fix build breakage
Message-ID: <20130625134419.GD12178@S2101-09.ap.freescale.net>
References: <1372160780-26172-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1372160780-26172-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 05:16:20PM +0530, Sachin Kamat wrote:
> asm/sched_clock.h does not exist. Use linux/sched_clock.h instead.
> Without this patch we get the following build error (introduced by commit
> c1967249 ("clocksource: Add Freescale Vybrid pit timer support")):
> 
> drivers/clocksource/vf_pit_timer.c:15:29: fatal error: asm/sched_clock.h:
> No such file or directory
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Jingchang Lu <b35083@freescale.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Shawn Guo <shawn.guo@linaro.org>

Thanks.  But there is already a patch [1].

Shawn

[1]
http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=2699339361a9bacb3fa663e6b8981a040cfca4ee

