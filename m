Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaKFK12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:27:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:41786 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaKFK11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:27:27 -0500
Message-ID: <545B4D09.6070102@linutronix.de>
Date: Thu, 06 Nov 2014 11:27:21 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, tony@atomide.com
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com
Subject: Re: [PATCH 00/13 v10] omap 8250 based UART + DMA
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de> <20141106031421.GA22185@kroah.com>
In-Reply-To: <20141106031421.GA22185@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 04:14 AM, Greg KH wrote:
> I've now applied the patches here that I could, if I have missed any,
> please let me know and resend.

Thank you Greg. I pulled your tty-testing and it seems to work on
am335x-evm/dra7-evm.

Tony, if you could please take the two .dts files then the series would
be complete (that one dma patch was applied by Vinod during the merge
window).

> 
> thanks,
> 
> greg k-h
> 
Sebastian
