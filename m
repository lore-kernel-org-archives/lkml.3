Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaJ0QkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:40:05 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:39711 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaJ0Qj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:39:59 -0400
MIME-Version: 1.0
In-Reply-To: <1412882541-10934-5-git-send-email-octavian.purdila@intel.com>
References: <1412882541-10934-1-git-send-email-octavian.purdila@intel.com>
	<1412882541-10934-5-git-send-email-octavian.purdila@intel.com>
Date: Mon, 27 Oct 2014 17:39:58 +0100
Message-ID: <CACRpkdbWGZmHMfRt0EmFrVTP2Vg7ykBVnRSiZsJAtydtL9hJDg@mail.gmail.com>
Subject: Re: [PATCH v7 4/4] gpio: add support for the Diolan DLN-2 USB GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Alexandre Courbot <gnurou@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Johan Hovold <johan@kernel.org>,
        Daniel Baluta <daniel.baluta@intel.com>, laurentiu.palcu@intel.com,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 9:22 PM, Octavian Purdila
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

Looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
