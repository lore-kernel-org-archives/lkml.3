Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbaDJLqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:46:07 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36382 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030248AbaDJLqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:46:05 -0400
MIME-Version: 1.0
X-Originating-IP: [95.21.193.102]
In-Reply-To: <1397127659.11914.94.camel@smile.fi.intel.com>
References: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
	<CAAVeFu+XV_wy9JzewGs0bcSA-ivQg-kzygMh_kt434rsYRQwHQ@mail.gmail.com>
	<534665B1.9090207@collabora.co.uk>
	<1397127659.11914.94.camel@smile.fi.intel.com>
Date: Thu, 10 Apr 2014 13:46:02 +0200
Message-ID: <CABxcv=kAk1Gwm6LHq2X5CFxM6Qo97WUZdmSwszuUiesz699Hdg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] add gpio_chip_ops to hold GPIO operations
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andy,

On Thu, Apr 10, 2014 at 1:00 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Thu, 2014-04-10 at 11:34 +0200, Javier Martinez Canillas wrote:
>> On 04/10/2014 09:36 AM, Alexandre Courbot wrote:
>> >
>> > "Since having the operations" maybe?
>> >
>>
>> Yes, since I'm not a native english speaker I sometimes miss some obvious
>> grammatical errors. I'll fix those when posting the final version with all the
>> drivers converted.
>
> JFYI: there is nice project called codespell [1].
>
> [1] git://github.com/lucasdemarchi/codespell.git

Interesting project, thanks a lot for the pointer.

Best regards,
Javier

>
> --
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-gpio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
