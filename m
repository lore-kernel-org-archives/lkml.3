Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3E3SaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:30:18 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64349 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab3E3SaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:30:13 -0400
MIME-Version: 1.0
In-Reply-To: <1369218646-29556-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369218646-29556-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 30 May 2013 20:30:12 +0200
Message-ID: <CACRpkda0h88N2UNWipmOWyXoww-Eg-k5hO84=+7qkV3poy8C=w@mail.gmail.com>
Subject: Re: [PATCH] gpio-lynxpoint: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 12:30 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> Since 0998d06310 "device-core: Ensure drvdata = NULL when no driver is bound",
> this is done by driver core after device_release or on probe failure. Thus we
> can remove all platform_set_drvdata(pdev, NULL) in drivers.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

I already had a patch from Jingoo Han for this in my patch queue,
so dropped this patch.

Yours,
Linus Walleij
