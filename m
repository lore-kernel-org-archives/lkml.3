Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170Ab3FTIkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:40:42 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34861 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3FTIkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:40:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130620080212.GO11878@intel.com>
References: <1371537818-19579-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CACRpkdYMiNnCy26px26ofY8MCbw_VSgOpOncS=5YK3vd9BC9yA@mail.gmail.com>
	<CAHp75VexskPUkqKhE2fowc=cscyGSvirz9d9igy37BveFYGVKA@mail.gmail.com>
	<CACRpkdZCjNGMxbnR7e_8x1GPxCLe5KzsY8ep8Unnqq4gFg07sg@mail.gmail.com>
	<CAHp75VdqOTUtp=LEN8hbxJq1E2-BxhxVW0BtHUYhW=-4soYqsQ@mail.gmail.com>
	<20130620080212.GO11878@intel.com>
Date: Thu, 20 Jun 2013 10:40:35 +0200
Message-ID: <CACRpkda4f-LOCUS8c0v0HyPV0UCBvxh7_VoAf5O+JB5dd1Eyyg@mail.gmail.com>
Subject: Re: [PATCH] gpio-langwell: remove Withney point support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Cohen <david.a.cohen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 10:02 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Thu, Jun 20, 2013 at 10:09:37AM +0300, Andy Shevchenko wrote:
>> On Thu, Jun 20, 2013 at 9:46 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> > On Wed, Jun 19, 2013 at 11:02 PM, Andy Shevchenko
>> > <andy.shevchenko@gmail.com> wrote:
>> >> On Wed, Jun 19, 2013 at 10:23 PM, Linus Walleij
>> >> <linus.walleij@linaro.org> wrote:
>> >>
>> >>> Please give some context though, Wikipedia says:
>> >>>
>> >>> Whitney Point is the codename of a PCH in the Oak Trail platform
>> >>> chipset for Atom Lincroft microprocessors.
>> >>> This has the following variations:
>> >>> 82SM35 (PCH SM35)
>> >>
>> >>> Does this mean that platform is not coming back to support Linux
>> >>> ever again
>> >>
>> >> I think it's very unluckily.
>> >> May be David could shed a light...
>> >
>> > Is that some kind of NACK?
>>
>> No, the opposite.
>> I meant it's very unluckily that we will have any Oak Trail user in future.
>
> You mean *unlikely*, right?
>
> AFAICT there are no real Oak Trail products outside Intel. It was
> superseded by Medfield.

Only lab boards then? OK I will keep this patch around.

Yours,
Linus Walleij
