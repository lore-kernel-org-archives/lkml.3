Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbaGPIWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:22:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:53875 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaGPIWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:22:34 -0400
Message-ID: <53C63642.7080208@linutronix.de>
Date: Wed, 16 Jul 2014 10:22:26 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 1/6] tty: serial: 8250 core: provide a function to export
 uart_8250_port
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>	<1404928177-26554-2-git-send-email-bigeasy@linutronix.de> <CAMFK0gtLHrYzWipw=9rp-cUZrKkzBAn_iXSetn016F7zvuZE0w@mail.gmail.com>
In-Reply-To: <CAMFK0gtLHrYzWipw=9rp-cUZrKkzBAn_iXSetn016F7zvuZE0w@mail.gmail.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 04:30 PM, Olivier Galibert wrote:
> On Wed, Jul 9, 2014 at 7:49 PM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
>> + * The lock assumption made here is none because runtime-pm suspend/resume
>> + * callbacks should not be invoked there is any operation performed on the port.
> 
> I think there's a missing "if"?

Thanks, fixed up.

> Best,
> 
>   OG.
> 

Sebastian
