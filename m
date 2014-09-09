Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaIITle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:41:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:55939 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaIITlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:41:32 -0400
Message-ID: <540F57E0.8030404@linutronix.de>
Date: Tue, 09 Sep 2014 21:41:20 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Frans Klaver <frans.klaver@xsens.com>
CC: linux-serial@vger.kernel.org, tony@atomide.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de> <20140908144616.GA22315@ci00147.xsens-tech.local> <20140908151501.GA22584@linutronix.de> <20140908183353.GB4686@ci00147.xsens-tech.local>
In-Reply-To: <20140908183353.GB4686@ci00147.xsens-tech.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 08:33 PM, Frans Klaver wrote:
> Thanks. I'll give it a spin on Wednesday.

Could you please pull the upcoming v9 first?

 git://git.breakpoint.cc/bigeasy/linux.git uart_v9_pre1

This solves a few of my am335x related issues.

The problem that the uart freezes on beagle board xm is still there.
>From what I can say is that the DMA transfer is started but not
completed and I can't reproduce it on dra7xx

> Thanks,
> Frans
> 

Sebastian
