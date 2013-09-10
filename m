Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3IJQ50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:57:26 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55433 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab3IJQ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:57:25 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130910153037.GA11227@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
	<1378817379-8238-2-git-send-email-lee.jones@linaro.org>
	<CAOesGMgySNLKo_H0h4MCbAWvyW0h2bWa96drWBpnhAYYQwH9mw@mail.gmail.com>
	<20130910153037.GA11227@lee--X1>
Date: Tue, 10 Sep 2013 09:57:24 -0700
Message-ID: <CAOesGMiBN5SaEY26SxGaw9E4ViR3cC0PcwNMEd4cLJZMfomprQ@mail.gmail.com>
Subject: Re: [PATCH 01/38] ARM: ux500: Remove PrimeCell IDs from Nomadik I2C
 DT nodes
From: Olof Johansson <olof@lixom.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LinusW <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[pruning out the iio list/people]

On Tue, Sep 10, 2013 at 8:30 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> On Tue, Sep 10, 2013 at 5:49 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> > Turns out that they're actually not required and the driver probes just
>> > fine without them. The ID is incorrect at the moment anyway. They actually
>> > currently specify the stn8815.
>> >
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> How did you test this patch? What hardware did you boot it on and with
>> what config?
>
> Snowball, u8500_defconfig.
>
> Why? Don't you have the same result with yours?

I have a very weird experience with snowball right now. I noticed this
yesterday when I decided to look at why multi_v7_defconfig doesn't
boot on it:

* u8500_defconfig doesn't boot as a DT kernel, since the machine ID is
still enabled. If I disable the machine ID, it doesn't boot.
* Same for multi_v7_defconfig, since that is only DT: It doesn't boot.

Unfortunately I can't get to my home network right now to double-check
boot logs to see if this has changed behavior recently, I'll have to
do that later today. It'd be interesting to hear if you have the same
experience w.r.t. DT on u8500_defconfig though.



-Olof
