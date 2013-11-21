Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3KUTmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:42:35 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35187 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3KUTmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:42:33 -0500
MIME-Version: 1.0
In-Reply-To: <1380893106-7550-1-git-send-email-linus.walleij@linaro.org>
References: <1380893106-7550-1-git-send-email-linus.walleij@linaro.org>
Date: Thu, 21 Nov 2013 20:42:32 +0100
Message-ID: <CACRpkda6XcEA3xri116q=U26Cm3BeMWv4Us40FCyxGj3o+DAFw@mail.gmail.com>
Subject: Re: [PATCH] irqchip: versatile FPGA: support cascaded interrupts from DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 3:25 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> The Versatile FPGA interrupt controller supports cascading interrupts,
> i.e. that its output is connected to the input of another interrupt
> controller. This makes it possible to pass a parent interrupt from
> the device tree and print it in the boot log if applicable.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> TGLX: I can take this through ARM SoC if you're happy with it
> and prefer it that way, but it merges just as fine as it is on
> the IRQ tree.

Ping on this!

Yours,
Linus Walleij
