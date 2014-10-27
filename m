Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaJ0QhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:37:08 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:61602 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaJ0QhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:37:05 -0400
MIME-Version: 1.0
In-Reply-To: <1412882541-10934-4-git-send-email-octavian.purdila@intel.com>
References: <1412882541-10934-1-git-send-email-octavian.purdila@intel.com>
	<1412882541-10934-4-git-send-email-octavian.purdila@intel.com>
Date: Mon, 27 Oct 2014 17:37:04 +0100
Message-ID: <CACRpkdZPsuft+_d7tE6a3fhMLAKcSzvGvHxyqtM55DyUKAYOpw@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] gpiolib: add irq_not_threaded flag to gpio_chip
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

> Some GPIO chips (e.g. the DLN2 USB adapter) have blocking get/set
> operation but do not need a threaded irq handler.
>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

This is already upstream now. Rebase and you can drop this patch.

Yours,
Linus Walleij
