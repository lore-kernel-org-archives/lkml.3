Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3LKEaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 23:30:22 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:48432 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3LKEaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 23:30:21 -0500
Message-ID: <1386736215.7152.259.camel@host5.omatika.ru>
Subject: Re: [PATCH 02/11] arm: pxa27x: support ICP DAS LP-8x4x
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Olof Johansson <olof@lixom.net>, Daniel Mack <zonque@gmail.com>
Date: Wed, 11 Dec 2013 08:30:15 +0400
In-Reply-To: <201312102257.33942.arnd@arndb.de>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
	 <CACRpkdYF-O6Qgjue6x+R6fVuSXSyO4YHw1meusuyQhtSA9PnvQ@mail.gmail.com>
	 <1386706817.7152.254.camel@host5.omatika.ru>
	 <201312102257.33942.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 22:57 +0100, Arnd Bergmann wrote:
> It should be possible to make it a loadable module, with deferred
> probing etc. You wouldn't use IRQCHIP_DECLARE() for this though,
> but instead have a platform driver that sets up the irq domain.

Thanks for explaning.

> It probably makes sense to have a single driver file for the
> FPGA device that does this, and only split out the other devices
> from it that consume the irqs.

Is drivers/irqchip/ the right place this driver?

I am asking because there is no tristate config options in
drivers/irqchip/Kconfig at the moment.


