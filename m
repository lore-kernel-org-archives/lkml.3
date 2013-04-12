Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3DLWFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:05:07 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:54598 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3DLWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:05:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130412130936.3f428cc9@hyperion>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
	<1365441321-21952-3-git-send-email-kevin.strasser@linux.intel.com>
	<CACRpkdaU-QT-VBiG8i5XreEP-DvTosHeptUo+5vdmSyi0=uWTw@mail.gmail.com>
	<20130412130936.3f428cc9@hyperion>
Date: Sat, 13 Apr 2013 00:05:03 +0200
Message-ID: <CACRpkdZJ++E28Z_25SdVOHrvjGwz+HVYsT3pax309gvAtk-_YA@mail.gmail.com>
Subject: Re: [PATCH 3/4] gpio: Kontron PLD gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Michael Brunner <mibru@gmx.de>
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 1:09 PM, Michael Brunner <mibru@gmx.de> wrote:

>> (...)
>> > +struct kempld_gpio_data {
>> > +       struct gpio_chip                chip;
>> > +       int                             irq;
>> > +       struct kempld_device_data       *pld;
>> > +       uint16_t                        mask;
>>
>> Just u16?
>
> The specification allows 16 GPIOs for this device, therefore this seems
> to be the right size. Would it be better to use another type instead?

Ah, I was just asking you to use "u16" instead of "uint16_t".

Yours,
Linus Walleij
