Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaIYPOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:14:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:34176 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIYPOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:14:12 -0400
Date: Thu, 25 Sep 2014 17:14:03 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140925151403.GH19396@linutronix.de>
References: <5411C810.7070906@linutronix.de>
 <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com>
 <54129F6C.7040508@linutronix.de>
 <20140912094010.GE28458@ci00147.xsens-tech.local>
 <5412C21A.8020203@linutronix.de>
 <20140912102816.GF28458@ci00147.xsens-tech.local>
 <541716DC.9020904@linutronix.de>
 <20140917102812.GA20438@ci00147.xsens-tech.local>
 <20140921204100.GA10111@linutronix.de>
 <20140922092853.GH20438@ci00147.xsens-tech.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140922092853.GH20438@ci00147.xsens-tech.local>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frans Klaver | 2014-09-22 11:28:54 [+0200]:

>I guess then we'd still have to answer the question why the yocto build
>calls set_termios() so often, but that's not on you then. Did you notice
>it even changing settings? We might want to fix this even if the kernel
>should be able to cope.

could you please test uart_v10_pre3? I dropped a few register sets and
delayed the register update until TX-DMA is complete. I am traveling
currently and have only my boneblack and it passes my limited testing.
If it solves your problems, too then I would address Heikki's latest
comments and prepare the final v10 (and I hope I didn't break beagle
board in between).

>Thanks again,
>Frans

Sebastian
