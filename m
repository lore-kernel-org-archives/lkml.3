Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3LJPzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:55:24 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:35305
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab3LJPzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:55:20 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zz98dI936eI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh2a8h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h286p1155h)
Message-ID: <1386690820.6211.4.camel@linux-builds1>
Subject: Re: [PATCHv4] clocksource: dw_apb_timer_of: Fix read_sched_clock
From: Dinh Nguyen <dinguyen@altera.com>
To: Ingo Molnar <mingo@kernel.org>
CC: <dinh.linux@gmail.com>, <daniel.lezcano@linaro.org>, <tglx@linutronix.de>,
        <jamie@jamieiles.com>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <heiko@sntech.de>
Date: Tue, 10 Dec 2013 09:53:40 -0600
In-Reply-To: <20131210155349.GC1995@gmail.com>
References: <1386690395-27182-1-git-send-email-dinguyen@altera.com>
	 <20131210155349.GC1995@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 16:53 +0100, Ingo Molnar wrote:
> * dinguyen@altera.com <dinguyen@altera.com> wrote:
> 
> > From: Dinh Nguyen <dinguyen@altera.com>
> > 
> > The read_sched_clock should return the ~value because the clock is a
> > countdown implementation. read_sched_clock() should be the same as
> > __apbt_read_clocksource().
> > 
> > Maintain backwards compatibility for "dw-apb-timer-sp" and
> > "dw-apb-timer-osc".
> 
> Are these two independent fixes? If yes then they should be in 
> separate patches. In general we want to apply minimized, obvious, 
> single-purpose fix patches.

Yes, I will split them.

Thanks,
Dinh
> 
> Thanks,
> 
> 	Ingo
> 



