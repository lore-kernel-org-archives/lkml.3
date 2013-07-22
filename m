Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab3GVUvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:51:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46291 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab3GVUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:51:42 -0400
MIME-Version: 1.0
In-Reply-To: <1373457340-16666-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1373457340-16666-6-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 22 Jul 2013 22:51:41 +0200
Message-ID: <CACRpkdZowZtF45hPMhvBrVmurRnTO32znwjKpjDUY22hWhQDLw@mail.gmail.com>
Subject: Re: [PATCH 5/5] pinctrl-baytrail: fix to avoid sparse warnings
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

> There are couple of sparse warnings we could avoid if we use a bit verbose
> version of the code in byt_gpio_direction_output().
>
> drivers/pinctrl/pinctrl-baytrail.c:266:45: warning: dubious: x | !y
> drivers/pinctrl/pinctrl-baytrail.c:267:36: warning: dubious: x | !y
>
> Additionally simplify a bit the code in byt_gpio_direction_input().
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Patch applied.

Yours,
Linus Walleij
