Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935095Ab3FSTXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:23:46 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:52064 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935068Ab3FSTXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:23:45 -0400
MIME-Version: 1.0
In-Reply-To: <1371537818-19579-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1371537818-19579-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 19 Jun 2013 21:23:44 +0200
Message-ID: <CACRpkdYMiNnCy26px26ofY8MCbw_VSgOpOncS=5YK3vd9BC9yA@mail.gmail.com>
Subject: Re: [PATCH] gpio-langwell: remove Withney point support
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 8:43 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> It seems there is no user of the wp_gpio driver in the kernel. Let's remove it.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

OK patch applied.

Please give some context though, Wikipedia says:

Whitney Point is the codename of a PCH in the Oak Trail platform
chipset for Atom Lincroft microprocessors.
This has the following variations:
82SM35 (PCH SM35)

Does this mean that platform is not coming back to support Linux
ever again like it was a stepping stone or something?

Yours,
Linus Walleij
