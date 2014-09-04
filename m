Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaIDQcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:32:52 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:47608 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbaIDQct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <1409349654-24841-4-git-send-email-octavian.purdila@intel.com>
References: <1409349654-24841-1-git-send-email-octavian.purdila@intel.com>
	<1409349654-24841-4-git-send-email-octavian.purdila@intel.com>
Date: Thu, 4 Sep 2014 18:32:46 +0200
Message-ID: <CACRpkdbu+hwXtM=Xqur6_Z4C3UkQRDu_YQviZ4F+xAUvX63q0g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] gpio: add support for the Diolan DLN-2 USB GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Alexandre Courbot <gnurou@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        johan@kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Daniel Baluta <daniel.baluta@intel.com>, laurentiu.palcu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 12:00 AM, Octavian Purdila
<octavian.purdila@intel.com> wrote:

> From: Daniel Baluta <daniel.baluta@intel.com>
>
> This patch adds GPIO and IRQ support for the Diolan DLN-2 GPIO module.
>
> Information about the USB protocol interface can be found in the
> Programmer's Reference Manual [1], see section 2.9 for the GPIO
> module commands and responses.
>
> [1] https://www.diolan.com/downloads/dln-api-manual.pdf
>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

I like this version. I assume you need to funnel it with the
rest of the patches through the MFD tree so:

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
