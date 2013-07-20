Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3GTVee (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 17:34:34 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37161 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab3GTVed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 17:34:33 -0400
Message-ID: <51EB0265.2030508@linaro.org>
Date: Sat, 20 Jul 2013 23:34:29 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonas Jensen <jonas.jensen@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9] ARM: clocksource: add support for MOXA ART SoCs
References: <1373985880-23469-1-git-send-email-jonas.jensen@gmail.com> <1374048297-4321-1-git-send-email-jonas.jensen@gmail.com> <CACRpkdYktthfRsn9=9GjphXUbOEAswdCZCM48KFK2WRgBdj-Qw@mail.gmail.com>
In-Reply-To: <CACRpkdYktthfRsn9=9GjphXUbOEAswdCZCM48KFK2WRgBdj-Qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2013 10:45 PM, Linus Walleij wrote:
> On Wed, Jul 17, 2013 at 10:04 AM, Jonas Jensen <jonas.jensen@gmail.com> wrote:
> 
>> +#include <linux/clk.h>
>> +#include <linux/clockchips.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/irq.h>
>> +#include <linux/irqreturn.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/io.h>
>> +#include <linux/clocksource.h>
> 
> #include <linux/bitops.h>
> 
>> +#define TIMEREG_CR_1_ENABLE    BIT(0)
> 
> Because BIT() comes from there. And we shall not rely on
> implicit #inclusion.

Hi Jonas,

as the patchset is already merged could you fix it with a separate patch ?

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

