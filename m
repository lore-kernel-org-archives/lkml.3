Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaLBJ3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:29:07 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:61409 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaLBJ3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:29:03 -0500
Date: Tue, 2 Dec 2014 09:28:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Muthu Mani <muth@cypress.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Alexandre Courbot <gnurou@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>
Subject: Re: [PATCH v4 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO
 adapter
Message-ID: <20141202092856.GD12068@x1>
References: <1417192911-16719-1-git-send-email-muth@cypress.com>
 <CACRpkdYbbheP5KTuj7f+2cJXrOjjkRZjR0-bth1DF3kCig6n5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYbbheP5KTuj7f+2cJXrOjjkRZjR0-bth1DF3kCig6n5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2014, Linus Walleij wrote:

> On Fri, Nov 28, 2014 at 5:41 PM, Muthu Mani <muth@cypress.com> wrote:
> 
> > Adds support for USB-GPIO interface of Cypress Semiconductor
> > CYUSBS234 USB-Serial Bridge controller.
> >
> > The GPIO get/set can be done through vendor command on control endpoint
> > for the configured gpios.
> >
> > Details about the device can be found at:
> > http://www.cypress.com/?rID=84126
> >
> > Signed-off-by: Muthu Mani <muth@cypress.com>
> > Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> > ---
> > Changes since v3:
> 
> (..)
> > +config GPIO_CYUSBS23X
> > +       tristate "CYUSBS23x GPIO support"
> > +       depends on MFD_CYUSBS23X && USB
> 
> Doesn't MFD_CYUSV23X already depend on USB?

Yup.

> > +#include <linux/kernel.h>
> > +#include <linux/errno.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +#include <linux/mutex.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include <linux/usb.h>
> > +#include <linux/gpio.h>
> > +
> > +#include <linux/mfd/cyusbs23x.h>
> 
> Why this arbitrary newlines? Add this
> 
> #include <linus/bitops.h>

Narcissist. =;-)

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
