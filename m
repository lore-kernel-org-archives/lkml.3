Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3E1Sg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:36:59 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:57539 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3E1Sg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:36:58 -0400
MIME-Version: 1.0
X-Originating-IP: [84.109.219.89]
In-Reply-To: <CAHp75VdzX=8hjRX5PtO1q-uAa5AwNjoNN5P24ruR8ifvA-8umA@mail.gmail.com>
References: <1368609586-20905-1-git-send-email-leon@leon.nu>
 <20130523083751.GC22683@gmail.com> <CALq1K=Las2mwV9x6ajEUDYg6nLbcK2KVLK8TH2B1f=9fQ7JfTg@mail.gmail.com>
 <20130528090213.GB22683@gmail.com> <CAHp75VdzX=8hjRX5PtO1q-uAa5AwNjoNN5P24ruR8ifvA-8umA@mail.gmail.com>
From: Leon Romanovsky <leon@leon.nu>
Date: Tue, 28 May 2013 21:36:36 +0300
Message-ID: <CALq1K=LGuA4Jqa0qmenLNJZCbLf4XhZoA-wd-pkcR+bMbenBGw@mail.gmail.com>
Subject: Re: [PATCH] drivers: mfd: tps65912: Convert to use devm_kzalloc
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 7:24 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Tue, May 28, 2013 at 12:02 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> On Mon, 27 May 2013, Leon Romanovsky wrote:
>
>>> > > +     init_data = devm_kzalloc(&tps65912->dev,
>
> There is an obvious typo: no need of & here if I got it correctly.
>
>> drivers/mfd/tps65912-core.c: In function ‘tps65912_device_init’:
>> drivers/mfd/tps65912-core.c:131:18: warning: passing argument 1 of ‘devm_kzalloc’ from incompatible pointer type [enabled by default]
>> In file included from include/linux/platform_device.h:14:0,
>>                  from include/linux/mfd/core.h:17,
>>                  from drivers/mfd/tps65912-core.c:21:
>> include/linux/device.h:574:14: note: expected ‘struct device *’ but argument is of type ‘struct device **’
You are absolutely right, I sent the wrong patch with typo :(

Lee,
Do I need to resend it ? Or you can fix it by yourself ?


>
> --
> With Best Regards,
> Andy Shevchenko



--
Leon Romanovsky | Independent Linux Consultant
        www.leon.nu | leon@leon.nu
