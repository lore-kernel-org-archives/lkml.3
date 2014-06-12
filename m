Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbaFLHzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:55:24 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:59723 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbaFLHzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:55:22 -0400
MIME-Version: 1.0
In-Reply-To: <538EB81B.3090807@gmx.de>
References: <1401452797-29521-1-git-send-email-lee.jones@linaro.org>
	<1401452797-29521-2-git-send-email-lee.jones@linaro.org>
	<20140530123656.GC2742@katana>
	<20140530133405.GB29731@lee--X1>
	<20140530174800.GA4917@katana>
	<20140530192516.GA4319@lee--X1>
	<20140531134805.GA3287@katana>
	<CACRpkdZvyfA0aaJe3YuevXfA2pTZLRPZ3mQpitL6qD7=qE0Xyg@mail.gmail.com>
	<538C8A59.2070907@gmx.de>
	<CACRpkdbo9_xo6j7JBcjiuk6eYkqyaeMYLFsH3VczxotOmVRh1Q@mail.gmail.com>
	<538EB81B.3090807@gmx.de>
Date: Thu, 12 Jun 2014 09:55:21 +0200
Message-ID: <CACRpkda3bL=y3Dmkf59LT97Liep=XEzgE3P-YngLeD_w1qcAzQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: Make I2C ID tables non-mandatory for DT'ed and/or
 ACPI'ed devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Michael Lawnick <ml.lawnick@gmx.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 8:09 AM, Michael Lawnick <ml.lawnick@gmx.de> wrote:
> Am 03.06.2014 13:18, schrieb Linus Walleij:
>> On Mon, Jun 2, 2014 at 4:29 PM, Michael Lawnick <ml.lawnick@gmx.de> wrote:
>>>
>>> Am 02.06.2014 14:16, schrieb Linus Walleij:
>>
>>
>>>> Is this really so useful on embedded systems?
>>>>
>>>> I was under the impression that this method was something used
>>>> on say PC desktops with temperature monitors and EEPROMs
>>>> on some I2C link on the PCB, usage entirely optional and fun
>>>> for userspace hacks.
>>>>
>>> We use it for dynamic instantiating whole subsystems with multiplexers,
>>> sensors, controllers in an embedded system. The device list is taken from
>>> an
>>> I2C eeprom which gets read on hotplug.
>>
>>
>> Does this mean that you have stored the names (strings) that are used
>> by the Linux kernel for identifying the devices into your EEPROM?
>>
>> That means that you have made the kernel-internal device driver names
>> an ABI which is unfortunate :-/
>>
>> This is one of the reasons to why we insist on device tree: OS neutral
>> hardware description.
>
> The eeprom contains a device tree that is dynamically merged.

That is a kind of way of saying "yes we made the kernel-internal
driver named an ABI" I guess?

Yours,
Linus Walleij
