Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3FTGqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:46:09 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:64503 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3FTGqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:46:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75VexskPUkqKhE2fowc=cscyGSvirz9d9igy37BveFYGVKA@mail.gmail.com>
References: <1371537818-19579-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CACRpkdYMiNnCy26px26ofY8MCbw_VSgOpOncS=5YK3vd9BC9yA@mail.gmail.com>
	<CAHp75VexskPUkqKhE2fowc=cscyGSvirz9d9igy37BveFYGVKA@mail.gmail.com>
Date: Thu, 20 Jun 2013 08:46:07 +0200
Message-ID: <CACRpkdZCjNGMxbnR7e_8x1GPxCLe5KzsY8ep8Unnqq4gFg07sg@mail.gmail.com>
Subject: Re: [PATCH] gpio-langwell: remove Withney point support
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 11:02 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Wed, Jun 19, 2013 at 10:23 PM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
>
>> Please give some context though, Wikipedia says:
>>
>> Whitney Point is the codename of a PCH in the Oak Trail platform
>> chipset for Atom Lincroft microprocessors.
>> This has the following variations:
>> 82SM35 (PCH SM35)
>
>> Does this mean that platform is not coming back to support Linux
>> ever again
>
> I think it's very unluckily.
> May be David could shed a light...

Is that some kind of NACK? I will pull this patch out if it is
possible that support is useful for the near future.

Yours,
Linus Walleij
