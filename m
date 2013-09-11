Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3IKLNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:13:32 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:55598 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3IKLNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAF2Aj3iPdqM-+FQ7R9MZ-6jV1Q1me9TG1P4cEGA7fSBBYH92zA@mail.gmail.com>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
	<1378817379-8238-2-git-send-email-lee.jones@linaro.org>
	<CAOesGMgySNLKo_H0h4MCbAWvyW0h2bWa96drWBpnhAYYQwH9mw@mail.gmail.com>
	<20130910153037.GA11227@lee--X1>
	<CAOesGMiBN5SaEY26SxGaw9E4ViR3cC0PcwNMEd4cLJZMfomprQ@mail.gmail.com>
	<CACRpkdY24uU=tXirJqrxLH-45ORFGybJOg-2tDOkpSmFUQUiiw@mail.gmail.com>
	<20130911081911.GI11227@lee--X1>
	<CACRpkdY6v+LMggLBdfKc3VUPmRZXTf1zBi4a93EPhQeo21wMeQ@mail.gmail.com>
	<CAF2Aj3iPdqM-+FQ7R9MZ-6jV1Q1me9TG1P4cEGA7fSBBYH92zA@mail.gmail.com>
Date: Wed, 11 Sep 2013 13:13:29 +0200
Message-ID: <CACRpkdYfeao6bvwjq7YJhBNCoC_JVxPTwYzPPiWM0tgUQreJKg@mail.gmail.com>
Subject: Re: [PATCH 01/38] ARM: ux500: Remove PrimeCell IDs from Nomadik I2C
 DT nodes
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 11:39 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On 11 Sep 2013 10:33, "Linus Walleij" <linus.walleij@linaro.org> wrote:

>> No it was something transient, after a clean rebuild it boots
>> just fine. :-/
>>
>> I'll see if I can boot the same uImage on the Snowball too.

Yeah Snowball boots the same DT image with just some random
dmesg noise from Torvalds HEAD:

U8500 $ mmc rescan 1 ; fat load mmc 1 0x0 /uImage ; bootm 0x0
Partition info retrieved
Reading /uImage

8997342 bytes read
## Booting kernel from Legacy Image at 00000000 ...
   Image Name:   Ux500 Device Tree kernel
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    8997278 Bytes =  8.6 MB
   Load Address: 00008000
   Entry Point:  00008000
   Loading Kernel Image ... OK
OK

Starting kernel ...

Uncompressing Linux... done, booting the kernel.
Booting Linux on physical CPU 0x300
Linux version 3.11.0-09031-ga22a0fd (linus@localhost.localdomain) (gcc
version 4.8.2 20130805 (prerelease) (crosstool-NG
linaro-1.13.1-4.8-2013.08 - Linaro GCC 2013.08) ) #48 SMP PREEMPT Wed
Sep 11 11:14:36 CEST 2013
CPU: ARMv7 Processor [412fc091] revision 1 (ARMv7), cr=10c5387d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine: ST-Ericsson Ux5x0 platform (Device Tree Support), model:
ST-Ericsson HREF (v60+) platform with Device Tree
Only cachepolicy=writeback supported on ARMv6 and later
Memory policy: ECC disabled, Data cache writealloc
DB8500 v2.1 [0x008500b1]
(...)

I don't know what is the problem with Olof's machine :-/

Olof do you want a copy of my uImage?

Yours,
Linus Walleij
