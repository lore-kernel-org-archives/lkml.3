Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3FQJU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:20:59 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:48322 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3FQJU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:20:58 -0400
MIME-Version: 1.0
In-Reply-To: <1371228049-27080-5-git-send-email-javier.martinez@collabora.co.uk>
References: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
	<1371228049-27080-5-git-send-email-javier.martinez@collabora.co.uk>
Date: Mon, 17 Jun 2013 11:20:57 +0200
Message-ID: <CACRpkdafxpwuaUHLb3uHiPNrKLsmcekqG1ATQKj8fgz+ekXmDg@mail.gmail.com>
Subject: Re: [PATCH 4/7] mfd: stmpe: use irq_get_trigger_type() to get IRQ flags
From: Linus Walleij <linus.walleij@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 6:40 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:

> Use irq_get_trigger_type() to get the IRQ trigger type flags
> instead calling irqd_get_trigger_type(irq_get_irq_data(irq))
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

If you get the other patches ACKed.

Yours,
Linus Walleij
