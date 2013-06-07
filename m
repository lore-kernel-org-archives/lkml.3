Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3FGHOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:14:33 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:36677 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3FGHOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:14:20 -0400
MIME-Version: 1.0
In-Reply-To: <1370440690-21898-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370440690-21898-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 7 Jun 2013 09:14:19 +0200
Message-ID: <CACRpkdYoP+9GokBEjHS_v3z1rh5V+07XXfnCmQ7Yqi2VdWfaSg@mail.gmail.com>
Subject: Re: [PATCH v1.2] gpiolib: append SFI helpers for GPIO API
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Cohen <david.a.cohen@intel.com>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 3:58 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> To support some (legacy) firmwares and platforms let's make life easier for
> their customers.
>
> This patch extracts SFI GPIO API from arch/x86/platform/mrst/mrst.c.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Len Brown <len.brown@intel.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
> Since v1.1:
>  - use container_of
>  - switch to kmemdup

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
