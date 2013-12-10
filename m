Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab3LJMrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:47:09 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:40597 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3LJMrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:47:06 -0500
Message-ID: <1386679620.7152.226.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 02/11] arm: pxa27x: support ICP DAS LP-8x4x
From: Sergei Ianovich <ynvich@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Date: Tue, 10 Dec 2013 16:47:00 +0400
In-Reply-To: <CACRpkdYVsGSyMS6sSTqqJ4XrE3GqpWkJsY7GDazi5ix7xjKQ=Q@mail.gmail.com>
References: <1385879185-22455-3-git-send-email-ynvich@gmail.com>
	 <1386348542-9584-1-git-send-email-ynvich@gmail.com>
	 <CACRpkdYVsGSyMS6sSTqqJ4XrE3GqpWkJsY7GDazi5ix7xjKQ=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 13:43 +0100, Linus Walleij wrote:
> Argh! Now you're adding another user for a legacy custom pin control
> implementation. But if noone is going to modernize PXA2xx what
> can we do :-/

I've rewritten the device to use device tree and posted patch series for
that.

I will also implement LP-8x4x custom irq controller in drivers/irqchip/

