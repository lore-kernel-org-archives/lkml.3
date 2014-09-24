Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaIXIyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:54:55 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:49397 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaIXIyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:54:52 -0400
MIME-Version: 1.0
In-Reply-To: <1411158165-25794-4-git-send-email-octavian.purdila@intel.com>
References: <1411158165-25794-1-git-send-email-octavian.purdila@intel.com>
	<1411158165-25794-4-git-send-email-octavian.purdila@intel.com>
Date: Wed, 24 Sep 2014 10:54:51 +0200
Message-ID: <CACRpkdbnXo9VhybkZeP7Z4b0pxCHorGJvbRw-dh_X0dWT2iC8g@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] gpiolib: add irq_not_threaded flag to gpio_chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Alexandre Courbot <gnurou@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        johan@kernel.org, Daniel Baluta <daniel.baluta@intel.com>,
        laurentiu.palcu@intel.com,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 10:22 PM, Octavian Purdila
<octavian.purdila@intel.com> wrote:

> Some GPIO chips (e.g. the DLN2 USB adapter) have blocking get/set
> operation but do not need a threaded irq handler.
>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

Usually I don't apply patches adding interfaces with no users, but
this seems very useful, so patch applied. I guess your driver will
appear on v3.19+ so then you can rely on this having been merged
for v3.18.

Yours,
Linus Walleij
