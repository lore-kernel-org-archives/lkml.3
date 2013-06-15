Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3FOWsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 18:48:43 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59769 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab3FOWsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 18:48:42 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda2isXNCrd8Auiv7bNtKYBH3cwRx6idebMDbDPZrbqfJQ@mail.gmail.com>
References: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
 <1370825362-11145-11-git-send-email-grant.likely@linaro.org>
 <CACRpkda+WD5dMoZ9s7mTLgOgUrm+EH3Mqxio=BuLTDr3aOEruw@mail.gmail.com>
 <CACxGe6tW+k6dN6gi6MoPQ2zehP4R+THmzFGZQkhOZGH7oS+S2g@mail.gmail.com>
 <CACRpkdZcnjwQNap=i+LvzEeEFwDFgHw2BD7KVAUCNh0mRtX26w@mail.gmail.com> <CACRpkda2isXNCrd8Auiv7bNtKYBH3cwRx6idebMDbDPZrbqfJQ@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Sat, 15 Jun 2013 23:48:22 +0100
X-Google-Sender-Auth: Z6IOC9KtDtGhCEECtzvUoxyGjCI
Message-ID: <CACxGe6tvSptNKJMz6eUXwahH0VbXVgnjdj2ARD1BfLiS-x6z_Q@mail.gmail.com>
Subject: Re: [RFC 10/10] irqchip: Make versatile fpga irq driver a generic chip
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 10:22 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Sat, Jun 15, 2013 at 11:19 PM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
>> It still works like a charm on the Integrator/AP.
>> Tested-by: Linus Walleij <linus.walleij@linaro.org>
>
> BTW here is the new hwirq output in /proc/interrupts and it's really nice:
>
> root@integrator:/proc cat interrupts
>            CPU0
>  17:       1845       pic   1  uart-pl010
>  22:      13716       pic   6  timer
>  24:          0       pic   8  rtc-pl030
> Err:          0

Glad you like it. :-)

g.
