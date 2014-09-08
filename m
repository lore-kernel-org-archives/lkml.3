Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaIHSZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:25:11 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:56755 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaIHSZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:25:09 -0400
X-ASG-Debug-ID: 1410200704-0759e778ba1619f40002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Mon, 8 Sep 2014 20:25:03 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-serial@vger.kernel.org>, <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
Message-ID: <20140908182503.GA4686@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
 <20140908144616.GA22315@ci00147.xsens-tech.local>
 <20140908151501.GA22584@linutronix.de>
 <20140908163313.GA25724@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140908163313.GA25724@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1410200705
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9288
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 06:33:13PM +0200, Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2014-09-08 17:15:01 [+0200]:
> 
> >* Frans Klaver | 2014-09-08 16:46:18 [+0200]:
> >
> >>- ncurses based applications (vi, less) don't play nice for me on the
> >>  console with this series. less doesn't show me anything. vi doesn't
> >>  return to console properly.
> >
> >Can you give a test case 
> 
> Okay. less. My am335x-evm freezes after a while for no obvious reason.
> The data that hits the RX fifo is still received but the TX won't do
> anything. The DMA request is pending, the FIFO level is @64 bytes and
> the UART doesn't make any progress.
> On beagle-board I see what you described: less on a file and nothing
> happens.

Exactly that, yes.

Frans
