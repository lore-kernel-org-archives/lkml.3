Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaDYJQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:16:23 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37756 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaDYJQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140424174741.GA23444@swsaberg01>
References: <cover.1398335771.git.anders.berg@lsi.com>
	<2386bd1367aa44741979461358a72dec89608597.1398335771.git.anders.berg@lsi.com>
	<CACRpkdbU6UashxCuPMDjEB_nbB=mXicGpjJy=HGC6r3qfxCtVQ@mail.gmail.com>
	<20140424174741.GA23444@swsaberg01>
Date: Fri, 25 Apr 2014 11:16:18 +0200
Message-ID: <CACRpkdZ1CA4mqcd5MA5HFmXSeGp-wspA0M6wnPbAsgL_gX76Fw@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] ARM: dts: Device tree for AXM55xx.
From: Linus Walleij <linus.walleij@linaro.org>
To: Anders Berg <anders.berg@lsi.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 7:47 PM, Anders Berg <anders.berg@lsi.com> wrote:
> On Thu, Apr 24, 2014 at 03:24:14PM +0200, Linus Walleij wrote:

>> One interrupt per CPU core?
>>
>> The drivers for these blocks will really just grab the first IRQ and
>> then I guess they
>> will only be able to execute on CPU0.
>>
>> It's definately correct to list all the IRQs here, but how do you envision
>> the drivers making use of them in the long run?
>
> It's one interrupt line per input pin (so with the current driver only the first pin
> is usable as interrupt source).

Hm I'm not sure I understand what a "pin" is in this concept ...
being maintainer of the pin control subsystem and all that really
triggers my interest.

Yours.
Linus Walleij
