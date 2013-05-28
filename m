Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934794Ab3E1QYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:24:04 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:52819 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934576Ab3E1QYC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:24:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130528090213.GB22683@gmail.com>
References: <1368609586-20905-1-git-send-email-leon@leon.nu>
	<20130523083751.GC22683@gmail.com>
	<CALq1K=Las2mwV9x6ajEUDYg6nLbcK2KVLK8TH2B1f=9fQ7JfTg@mail.gmail.com>
	<20130528090213.GB22683@gmail.com>
Date: Tue, 28 May 2013 19:24:00 +0300
Message-ID: <CAHp75VdzX=8hjRX5PtO1q-uAa5AwNjoNN5P24ruR8ifvA-8umA@mail.gmail.com>
Subject: Re: [PATCH] drivers: mfd: tps65912: Convert to use devm_kzalloc
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Leon Romanovsky <leon@leon.nu>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 12:02 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, 27 May 2013, Leon Romanovsky wrote:

>> > > +     init_data = devm_kzalloc(&tps65912->dev,

There is an obvious typo: no need of & here if I got it correctly.

> drivers/mfd/tps65912-core.c: In function ‘tps65912_device_init’:
> drivers/mfd/tps65912-core.c:131:18: warning: passing argument 1 of ‘devm_kzalloc’ from incompatible pointer type [enabled by default]
> In file included from include/linux/platform_device.h:14:0,
>                  from include/linux/mfd/core.h:17,
>                  from drivers/mfd/tps65912-core.c:21:
> include/linux/device.h:574:14: note: expected ‘struct device *’ but argument is of type ‘struct device **’

-- 
With Best Regards,
Andy Shevchenko
