Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3GVUtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:49:47 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:59931 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3GVUtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:49:46 -0400
MIME-Version: 1.0
In-Reply-To: <1373457340-16666-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1373457340-16666-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 22 Jul 2013 22:49:45 +0200
Message-ID: <CACRpkdYdm5Dx=E0ajqExyLAb0A8nmYBi2ZcA0xmRZpALBzgG8w@mail.gmail.com>
Subject: Re: [PATCH 3/5] pinctrl-baytrail: remove redundant ptr variable
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

> There is no need to have an additional variable in byt_gpio_reg().
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Patch applied.

Yours,
Linus Walleij
