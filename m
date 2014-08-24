Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaHXUSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 16:18:32 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:59925 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaHXUSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 16:18:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Vincent =?ISO-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>,
        linux-next@vger.kernel.org, linux-gpio@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH linux-next] irq: export handle_fasteoi_irq
Date: Sun, 24 Aug 2014 22:17:40 +0200
Message-ID: <4865705.6YRejgXUhp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-26-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408663880-29179-1-git-send-email-vincent.stehle@laposte.net>
References: <1408663880-29179-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:XZGkMnx54Z1cLFlTsioj9U0lKLQ8e8ZjbgRhxPRgvUG
 WVmW0WHxenNKO4OqY3TwUM9FzBU8cZkeqBNuvTkwXeil73iMfe
 wV2ySZpuplKQGTx7YOS5RzJz/M0T8dCelrsjSY8UZ3xDZUdCOa
 b487o8BhAo+BtSzCSYdHhbqCl8pxld5IrgFeYaX9fjK5Ho6w6M
 a3JAPDT2TUfZyISJAFBzSVdZffgL9+Jlfos7NRiuRSFkf6VisO
 pSVXW3c83MY1QRckWx3YdXv6P4lc3TEr8rJJyMCMHcSckhJPs1
 x3Di6p4TANUDthzKLfosDxsvFWE9kXjz4jUg4HwLztZ/y4lDEK
 Ln+nUsQ0GGSD7VwarIfk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2014 01:31:20 Vincent Stehlé wrote:
> Export handle_fasteoi_irq to be able to use it in e.g. the Zynq gpio driver
> since commit 6dd859508336 ("gpio: zynq: Fix IRQ handlers").
> 
> This fixes the following link issue:
> 
>   ERROR: "handle_fasteoi_irq" [drivers/gpio/gpio-zynq.ko] undefined!
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

I saw the same thing here and came up with the same fix.
