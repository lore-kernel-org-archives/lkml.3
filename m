Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaIPJTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:19:19 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:48792 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaIPJTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:19:16 -0400
X-ASG-Debug-ID: 1410857683-0759e77ab40560000f-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Tue, 16 Sep 2014 11:05:40 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, <tony@atomide.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140916090540.GJ28458@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <5411967A.6090406@hurleysoftware.com>
 <54119AAA.9080907@linutronix.de>
 <20140911151114.GD28458@ci00147.xsens-tech.local>
 <5411C810.7070906@linutronix.de>
 <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com>
 <54129F6C.7040508@linutronix.de>
 <20140912094010.GE28458@ci00147.xsens-tech.local>
 <5412C21A.8020203@linutronix.de>
 <20140912102816.GF28458@ci00147.xsens-tech.local>
 <541716DC.9020904@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <541716DC.9020904@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1410859152
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9541
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 06:42:04PM +0200, Sebastian Andrzej Siewior wrote:
> On 09/12/2014 12:28 PM, Frans Klaver wrote:
> > port config is 115200 8N1. I don't recall doing anything special. I
> > boot, login, less file and get a lock.
> 
> So I booted my mini Debian 7.6 (basic system + openssh) on my beagle
> bone black which is:
> 
> [    0.000000] AM335X ES2.0 (neon )
> 
> configured a console, login, invoked "less file". The file was shown, I
> hit on the space key so less shows me more of the file. No lock-up.
> I tried booting via NFS and MMC. I tried various files with less.
> 
> My dot config is here
> 	https://breakpoint.cc/config-am335x-bb.txt.xz
> 
> If there is nothing specific to the file you do less on I have no idea
> what else it could if it is not the config.

I'll test your config and go through the differences.

Thanks,
Frans
