Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaIQQZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:25:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:49892 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbaIQQZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:25:17 -0400
Message-ID: <5419B5E3.10307@linutronix.de>
Date: Wed, 17 Sep 2014 18:25:07 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-10-git-send-email-bigeasy@linutronix.de> <20140911111721.GB17476@xps8300> <54118AAB.2010205@linutronix.de> <5411967A.6090406@hurleysoftware.com> <54119AAA.9080907@linutronix.de> <5411B33F.10405@hurleysoftware.com> <54171B85.5060209@linutronix.de> <54186B89.8050505@linutronix.de> <54197C99.8030601@hurleysoftware.com>
In-Reply-To: <54197C99.8030601@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 02:20 PM, Peter Hurley wrote:
>> So I connected my am335x-evm
>> with beagle board xm because both of them have an old fashion UART
>> connector (instead those uart-to-usb). Both configured with HW-Flow and
>> I haven't seen the function invoked but I saw "port->icount.overrun"
>> being incremented. This shouldn't happen. So I am a little puzzled here…
> 
> Yeah, that's weird. Do you have a break-out box to confirm that RTS/CTS are
> being driven?

Yeah, I've been thinking about that, too. I will be gone next week and
hopefully when I get back I will something around to test this.

> 
> Regards,
> Peter Hurley
> 

Sebastian
