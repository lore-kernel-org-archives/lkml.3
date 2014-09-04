Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaIDQ3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:29:34 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:44791 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaIDQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:29:32 -0400
MIME-Version: 1.0
In-Reply-To: <1409335127-26712-4-git-send-email-soren.brinkmann@xilinx.com>
References: <1409335127-26712-1-git-send-email-soren.brinkmann@xilinx.com>
	<1409335127-26712-4-git-send-email-soren.brinkmann@xilinx.com>
Date: Thu, 4 Sep 2014 18:29:32 +0200
Message-ID: <CACRpkda14yOtM=sfsiy2vajd-u-+YbkXZAADQLVNurM4TdCDeQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: lib-sysfs: Add 'wakeup' attribute
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Ezra Savard <ezras@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 7:58 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> marking/unmarking a GPIO as wake IRQ.
> The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
> is associated with that GPIO and the irqchip implements set_wake().
> Writing 'enabled' to that file will enable wake for that GPIO, while
> writing 'disabled' will disable wake.
> Reading that file will return either 'disabled' or 'enabled' depening on
> the currently set flag for the GPIO's IRQ.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

While I do see the utility of this patch, any kind of interrupt and
related handling in userspace makes me super-stressed and
nervous.

I need wide consent for this and please post this patch separately
from the zynq-related patches.

Yours,
Linus Walleij
