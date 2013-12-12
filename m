Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3LLSe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:34:58 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:33587 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3LLSe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:34:56 -0500
MIME-Version: 1.0
In-Reply-To: <1386729148-16262-1-git-send-email-acourbot@nvidia.com>
References: <1386729148-16262-1-git-send-email-acourbot@nvidia.com>
Date: Thu, 12 Dec 2013 19:34:55 +0100
Message-ID: <CACRpkdYNL9gAqugPmRzDUEZGzUCtNCDX4Ro=vQXWkNtvJVw6bA@mail.gmail.com>
Subject: Re: [PATCH v3] gpiolib: return -ENOENT if no GPIO mapping exists
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 3:32 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Some devices drivers make use of optional GPIO parameters. For such
> drivers, it is important to discriminate between the case where no
> GPIO mapping has been defined for the function they are requesting, and
> the case where a mapping exists but an error occured while resolving it
> or when acquiring the GPIO.
>
> This patch changes the family of gpiod_get() functions such that they
> will return -ENOENT if and only if no GPIO mapping is defined for the
> requested function. Other error codes are used when an actual error
> occured during the GPIO resolution.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> Changes since v2:
> - Put string on a single line (thanks Andy!)
> - Added Andy's reviewed-by

Applied this v2 version with Mika's review tag.

Yours,
Linus Walleij
