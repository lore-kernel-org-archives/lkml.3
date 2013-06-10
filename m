Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab3FJHkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:40:10 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:61737 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3FJHkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:40:08 -0400
MIME-Version: 1.0
In-Reply-To: <1370825362-11145-11-git-send-email-grant.likely@linaro.org>
References: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
	<1370825362-11145-11-git-send-email-grant.likely@linaro.org>
Date: Mon, 10 Jun 2013 09:40:08 +0200
Message-ID: <CACRpkda+WD5dMoZ9s7mTLgOgUrm+EH3Mqxio=BuLTDr3aOEruw@mail.gmail.com>
Subject: Re: [RFC 10/10] irqchip: Make versatile fpga irq driver a generic chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
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

On Mon, Jun 10, 2013 at 2:49 AM, Grant Likely <grant.likely@linaro.org> wrote:

> This is an RFC patch to convert the versatile FPGA irq controller driver
> to use generic irq chip. It builds on the series that extends the
> generic chip code to allow a linear irq domain to contain one or more
> generic irq chips so that each interrupt controller doesn't need to hand
> code the generic chip setup.
>
> I've written this as a proof of concept to see if the new generic irq
> code does what it needs to. I had to extend it slightly to properly
> handle the valid mask used by the versatile FPGA driver.
>
> Tested on QEMU, but not on real hardware.

Is this the same as the one I tested previously?

If it need re-testing please push a branch and I'll take it
for a spin.

Yours.
Linus Walleij
