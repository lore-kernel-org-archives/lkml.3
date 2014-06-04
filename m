Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaFDGJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 02:09:43 -0400
Received: from mout.gmx.net ([212.227.15.19]:62933 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015AbaFDGJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 02:09:41 -0400
Message-ID: <538EB81B.3090807@gmx.de>
Date: Wed, 04 Jun 2014 08:09:31 +0200
From: Michael Lawnick <ml.lawnick@gmx.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] i2c: Make I2C ID tables non-mandatory for DT'ed and/or
 ACPI'ed devices
References: <1401452797-29521-1-git-send-email-lee.jones@linaro.org>	<1401452797-29521-2-git-send-email-lee.jones@linaro.org>	<20140530123656.GC2742@katana>	<20140530133405.GB29731@lee--X1>	<20140530174800.GA4917@katana>	<20140530192516.GA4319@lee--X1>	<20140531134805.GA3287@katana>	<CACRpkdZvyfA0aaJe3YuevXfA2pTZLRPZ3mQpitL6qD7=qE0Xyg@mail.gmail.com>	<538C8A59.2070907@gmx.de> <CACRpkdbo9_xo6j7JBcjiuk6eYkqyaeMYLFsH3VczxotOmVRh1Q@mail.gmail.com>
In-Reply-To: <CACRpkdbo9_xo6j7JBcjiuk6eYkqyaeMYLFsH3VczxotOmVRh1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Iggz67D/2mcWxfg/ETCsulL8DNWcIG+fFC2O+6ohdBKKYoUellV
 K6Dw/WSJJxkslyLc5VeUImcKinS/McD4kEvjtVyMkZ0lJ1jzMLjtPqTnycFg2nfN7RkunPg
 6h1XdYDDZVv3cr/b/HGqEruVjwF+WbHXpGZzIoHg4uebRuPeOjd+5HdSbQRf2BspcJu0EUN
 xvu3DAF08aTIupvPbpPPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.06.2014 13:18, schrieb Linus Walleij:
> On Mon, Jun 2, 2014 at 4:29 PM, Michael Lawnick <ml.lawnick@gmx.de> wrote:
>> Am 02.06.2014 14:16, schrieb Linus Walleij:
>
>>> Is this really so useful on embedded systems?
>>>
>>> I was under the impression that this method was something used
>>> on say PC desktops with temperature monitors and EEPROMs
>>> on some I2C link on the PCB, usage entirely optional and fun
>>> for userspace hacks.
>>>
>> We use it for dynamic instantiating whole subsystems with multiplexers,
>> sensors, controllers in an embedded system. The device list is taken from an
>> I2C eeprom which gets read on hotplug.
>
> Does this mean that you have stored the names (strings) that are used
> by the Linux kernel for identifying the devices into your EEPROM?
>
> That means that you have made the kernel-internal device driver names
> an ABI which is unfortunate :-/
>
> This is one of the reasons to why we insist on device tree: OS neutral
> hardware description.

The eeprom contains a device tree that is dynamically merged.

KR
Michael


