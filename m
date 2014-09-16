Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaIPQzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:55:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:43203 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbaIPQzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:55:49 -0400
Message-ID: <54186B89.8050505@linutronix.de>
Date: Tue, 16 Sep 2014 18:55:37 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-10-git-send-email-bigeasy@linutronix.de> <20140911111721.GB17476@xps8300> <54118AAB.2010205@linutronix.de> <5411967A.6090406@hurleysoftware.com> <54119AAA.9080907@linutronix.de> <5411B33F.10405@hurleysoftware.com> <54171B85.5060209@linutronix.de>
In-Reply-To: <54171B85.5060209@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 07:01 PM, Sebastian Andrzej Siewior wrote:
> On 09/11/2014 04:35 PM, Peter Hurley wrote:
>> I do need to find out if omap hardware sets UART_MSR_DCTS when auto CTS
>> is on. Would you mind running the debug patch below with HW flow control on?
> 
> I didn't forget about this. However I told minicom to use hardware flow
> control (and I see the driver set the HW bit) but I haven't seen that
> uart_handle_cts_change() has been invoked at all. I'm going to check
> two other boards and report then.

No, I don't get into this at all function. So I connected my am335x-evm
with beagle board xm because both of them have an old fashion UART
connector (instead those uart-to-usb). Both configured with HW-Flow and
I haven't seen the function invoked but I saw "port->icount.overrun"
being incremented. This shouldn't happen. So I am a little puzzled here…

>> Regards,
>> Peter Hurley
> 

Sebastian
