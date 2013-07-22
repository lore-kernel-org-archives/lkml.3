Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab3GVUup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:50:45 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:47718 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab3GVUuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <1373457340-16666-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1373457340-16666-5-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 22 Jul 2013 22:50:43 +0200
Message-ID: <CACRpkda8GER9TfgNdPyRVjkXRjnyDnHmQk73ziytR=5YJmOnRw@mail.gmail.com>
Subject: Re: [PATCH 4/5] pinctrl-baytrail: introduce to_byt_gpio() macro
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 1:55 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> The introduced macro helps to convert struct gpio_chip to struct byt_gpio.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Patch applied.

Yours,
Linus Walleij
