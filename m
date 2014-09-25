Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaIYJYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:24:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:60595 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaIYJYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:24:49 -0400
Date: Thu, 25 Sep 2014 11:24:46 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140925092446.GC19396@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <1410377411-26656-10-git-send-email-bigeasy@linutronix.de>
 <20140911111721.GB17476@xps8300>
 <54118AAB.2010205@linutronix.de>
 <5419B825.5000201@linutronix.de>
 <20140919102212.GA31784@xps8300>
 <541C0C64.5010206@linutronix.de>
 <20140922074605.GB26114@xps8300>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140922074605.GB26114@xps8300>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Heikki Krogerus | 2014-09-22 10:46:05 [+0300]:

>Well, there are no other SoCs at the moment that would need it, and
>it's actually possible that there never will be. So yes, just handle
>that also in the omap specific code.

Okay. So let me move the irq routine and the workarounds into omap then.

>Thanks,
>

Sebastian
