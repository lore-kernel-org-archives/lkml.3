Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaIHQp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:45:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:46216 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbaIHQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:45:25 -0400
Message-ID: <540DDD1D.201@linutronix.de>
Date: Mon, 08 Sep 2014 18:45:17 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 11/18] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de> <1409943773-7874-12-git-send-email-bigeasy@linutronix.de> <20140908164147.GG3238@atomide.com>
In-Reply-To: <20140908164147.GG3238@atomide.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 06:41 PM, Tony Lindgren wrote:
> * Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140905 12:28]:
>> This problem has not been seen on DRA7 or beaglebone (OMAP3). I am not
>> sure if this is UART-IP core specific or DMA engine.
> 
> Maybe check this comment for future reference too because
> beaglebone and bealeboard do different things for PM.. Do
> you mean Beaglebone or beagleboard? Or both?

Beagle bone (am335x) has the problem.
Beagle board xm (omap3) does not have the problem.
So let me replace "beaglebone" with "beagle board xm"

> 
> Regards,
> 
> Tony
> 

Sebastian
