Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab3FOUr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 16:47:26 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:44448 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3FOUrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 16:47:25 -0400
MIME-Version: 1.0
In-Reply-To: <51BB090F.5060002@linux.intel.com>
References: <1371135983-12592-1-git-send-email-mathias.nyman@linux.intel.com>
	<CACRpkdbuGeciwhh=FC=ekZ4di11rdPve7g79aG5wNvJAbAxx1g@mail.gmail.com>
	<51BB090F.5060002@linux.intel.com>
Date: Sat, 15 Jun 2013 22:47:24 +0200
Message-ID: <CACRpkdbbVuuPMp__Ba+Ru=GAFLyUcahPakrsa6yjnBShq_0Bww@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] gpio driver for Intel Baytrail platforms
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 2:14 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
> [Me]
>> I would still vote to put the thing in drivers/pinctrl anyway,
>> I am perfectly happy to house pure GPIO drivers there,
>> especially if they're obviously masking something more
>> pinctrl-like in reality, it will be way more flexible the day that
>> you just want to add "this one little quirk for this pin config
>> thing", then it'll fit just fine.
>>
>
> I'm fine with having it under drivers/pinctrl as a GPIO driver, either just
> as it is, or by using the pinctrl_gpio_range structure and helper functions
> such as gpio_to_pad(), once Christian Rupperts patch is accepted.

Christian's patch is merged into the pinctrl tree for v3.11.

> any naming preference?

> pinctrl-baytrail.c

Bingo!

Because the hardware is a pin controller after all.

I know there is some BIOS or ROM very much wanting it to look
simpler than it is, but it sure is a pin controller :-)

Thanks,
Linus Walleij
