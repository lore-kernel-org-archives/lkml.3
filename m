Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbaEPPyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:54:46 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:42483 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaEPPym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:54:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140514171309.64b49a45@canb.auug.org.au>
References: <20140514171309.64b49a45@canb.auug.org.au>
Date: Fri, 16 May 2014 17:54:42 +0200
Message-ID: <CACRpkdYh+aFcEkOQ4Xti4JzprrcDK17JwNGfTp8ZN1hxcwfpHQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the gpio tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Lee Jones <lee.jones@linaro.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 9:13 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus,
>
> After merging the gpio tree, today's linux-next build (powerpc allyesconfig)
> failed like this:
>
> drivers/mfd/stmpe.c: In function 'stmpe_irq_init':
> drivers/mfd/stmpe.c:1000:15: error: 'struct stmpe' has no member named 'irq_base'
>    base = stmpe->irq_base;
>                ^
>
> Caused by commit 3ba1d516d5fe ("mfd: stmpe: root out static GPIO and
> IRQ assignments").
>
> I have reverted that commit for today (and e013a5148882 "gpio: stmpe:
> switch to use gpiolib irqchip helpers" that depends on it).
>
> Also, that commit has no Signed-off-by for its committer (Lee).

Hm I know has struggled with this series sorry if it's all my fault :-/

I've un-pulled that branch from the GPIO tree, let's get the immutable
branch in MFD right first then.

Yours,
Linus Walleij
