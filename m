Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbaIJOQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:16:03 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:44889 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaIJOP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:15:59 -0400
X-ASG-Debug-ID: 1410358556-0759e73eff248260002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Wed, 10 Sep 2014 16:15:55 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-serial@vger.kernel.org>, <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
Message-ID: <20140910141554.GC22315@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
 <20140908144616.GA22315@ci00147.xsens-tech.local>
 <20140908151501.GA22584@linutronix.de>
 <20140908183353.GB4686@ci00147.xsens-tech.local>
 <540F57E0.8030404@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <540F57E0.8030404@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1410358556
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9340
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 09:41:20PM +0200, Sebastian Andrzej Siewior wrote:
> On 09/08/2014 08:33 PM, Frans Klaver wrote:
> > Thanks. I'll give it a spin on Wednesday.
> 
> Could you please pull the upcoming v9 first?
> 
>  git://git.breakpoint.cc/bigeasy/linux.git uart_v9_pre1
> 
> This solves a few of my am335x related issues.

Using v9_pre1, I get a kernel panic in edma_dma_pause() on echan->edesc
being NULL. I do get data before this happens. This is at high speed,
high rate. No mention of the irq having too much to do, though. The more
data I transmit, the more likely this is to occur.

I don't currently have the setup to lower the baudrate. I would probably
need to reproduce this on a beaglebone, instead of our custom board.
I'll see if I can do that.

If you need more info, just let me know.

Thanks,
Frans
