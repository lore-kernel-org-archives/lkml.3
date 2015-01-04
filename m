Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbbADW2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 17:28:14 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63808 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbbADW2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 17:28:11 -0500
Date: Sun, 4 Jan 2015 14:27:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linux Input <linux-input@vger.kernel.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Input: gpio_keys - allow separating gpio and irq in
 device tree
Message-ID: <20150104222743.GA31987@dtor-ws>
References: <20141208071930.GA20802@dtor-ws>
 <CACRpkdZ3PHGRG400Y9zo9RKGyyFm9qF7rZZa8PGpT6AStjUhYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ3PHGRG400Y9zo9RKGyyFm9qF7rZZa8PGpT6AStjUhYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 09:22:27AM +0100, Linus Walleij wrote:
> On Mon, Dec 8, 2014 at 8:19 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> 
> > This change allows specify interrupt for buttons separately form gpio,
> > potentially allowing to form several "clusters" of buttons on
> > different interrupts.
> >
> > Button defined without both gpio and irq in device tree is a hared error
> 
> hared?

Should have been "hard", sorry...

> 
> > instead of a warning now.
> >
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> ...but it would be nice if it could also be converted to use GPIO
> descriptors internally at some point.

Thanks.

-- 
Dmitry
