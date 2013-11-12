Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3KLSzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:55:53 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:40164 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab3KLSzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:55:50 -0500
MIME-Version: 1.0
In-Reply-To: <1382013695.29062.141.camel@smile>
References: <1381979015-28980-1-git-send-email-david.a.cohen@linux.intel.com>
	<1382013695.29062.141.camel@smile>
Date: Tue, 12 Nov 2013 19:55:49 +0100
Message-ID: <CACRpkdZG=Sa92qGqK4Jt-L1AVRmremK5tgn8O5-5JccUsZDHTA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: append SFI helpers for GPIO API
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sfi-devel@simplefirmware.org,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 2:41 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Wed, 2013-10-16 at 20:03 -0700, David Cohen wrote:
>> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>
>> To support some (legacy) firmwares and platforms let's make life easier for
>> their customers.
>
>> +int sfi_get_gpio_by_name(const char *name)
>> +{
>> +     struct sfi_gpio_table_entry *pentry = sfi_gpio_table;
>> +     int i;
>> +
>> +     if (!pentry)
>> +             return -1;
>
> ^^^^ It seems an old version.
>
> New version was published while ago and even has an ACK from Linus:
>
> http://www.spinics.net/lists/kernel/msg1545960.html

So what is happening to this thing?

Is there some newer patch I should be merging?

Yours,
Linus Walleij
