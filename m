Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaCGGRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:17:00 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:39141 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaCGGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:16:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140307145925.8f09601ffcefcc65e7837e72@canb.auug.org.au>
References: <20140307145925.8f09601ffcefcc65e7837e72@canb.auug.org.au>
Date: Fri, 7 Mar 2014 14:16:58 +0800
Message-ID: <CACRpkdZ4mbmQjjhbEHKZwGfSX2AY9+RE4A1oPmaSO4Bn3RFgvw@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the gpio tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>, Alan Tull <atull@altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 11:59 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus,
>
> After merging the gpio tree, today's (and yesterday's) linux-next build
> (x86_64 allmodconfig among others) produced this warning:
>
> kernel/irq/Kconfig:41:error: recursive dependency detected!
> kernel/irq/Kconfig:41:  symbol GENERIC_IRQ_CHIP is selected by GPIO_DWAPB
> drivers/gpio/Kconfig:131:       symbol GPIO_DWAPB depends on IRQ_DOMAIN
> kernel/irq/Kconfig:46:  symbol IRQ_DOMAIN is selected by GENERIC_IRQ_CHIP
>
> Caused by commit 7779b3455697 ("gpio: add a driver for the Synopsys
> DesignWare APB GPIO block").

Thanks Stephen, I merged a patch from Alan Tull earlier today fixing this
problem.

Yours,
Linus Walleij
