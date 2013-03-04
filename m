Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3CDCdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:33:08 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:61749 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab3CDCdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:33:05 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: build failure after merge of the gpio tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <20130304124513.cf97f6249b0759a1ea1cb34d@canb.auug.org.au>
References: <20130304124513.cf97f6249b0759a1ea1cb34d@canb.auug.org.au>
Date: Mon, 04 Mar 2013 10:32:31 +0800
Message-Id: <20130304023231.9DB013E14C0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013 12:45:13 +1100, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
> 
> After merging the gpio tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/gpio/gpio-stmpe.c: In function 'stmpe_gpio_irq_init':
> drivers/gpio/gpio-stmpe.c:313:23: error: 'struct gpio_chip' has no member named 'of_node'
> drivers/gpio/gpio-stmpe.c:316:61: error: 'struct gpio_chip' has no member named 'of_node'
> drivers/gpio/gpio-stmpe.c: In function 'stmpe_gpio_probe':
> drivers/gpio/gpio-stmpe.c:351:18: error: 'struct gpio_chip' has no member named 'of_node'
> 
> Caused by commit f7719903b7c7 ("").
> 
> I have used the gpio tree from next-20130301 for today.

Yup, I messed that one up. I've now pushed out a fixed branch.

g.

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
