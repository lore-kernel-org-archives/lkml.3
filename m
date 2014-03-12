Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaCLKWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:22:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55607 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaCLKWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:22:41 -0400
Message-ID: <5320356D.3010703@gmail.com>
Date: Wed, 12 Mar 2014 11:22:37 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        b.brezillon@overkiz.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCHv5 0/9] Device tree support for the at91sam9rlek
References: <1394617425-641-1-git-send-email-alexandre.belloni@free-electrons.com> <5320334C.7060206@atmel.com> <5320352B.7040707@gmail.com>
In-Reply-To: <5320352B.7040707@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/03/2014 11:21, Boris BREZILLON a écrit :
> Le 12/03/2014 11:13, Nicolas Ferre a écrit :
>> On 12/03/2014 10:43, Alexandre Belloni :
>>> This series adds DT support for the at91sam9rl SoC, then the 
>>> at91sam9rl-ek
>>> evaluation board.
>>>
>>> While the at91sam9rl dtsi should be almost complete (still missing 
>>> LCD and
>>> touchscreen bits). The at91sam9rlek DT now support the following tested
>>> features:
>>>   - MMC
>>>   - dbgu
>>>   - usart1
>>>   - watchdog
>>>   - nand
>>>   - leds
>>>   - buttons
>>>   - common clock framework
>>>
>>> Next:
>>>   - spi
>>>   - dataflash
>>>   - i2c
>>>   - lcd
>>>   - touchscreen
>>>   - usb gadget
>>>   - audio
>>>
>>> Changes since v4:
>>>   - correct a typo in the pwm clock name
>>>   - add an entry for the pwm clock in the board file lookup table
>>>   - reorder pinctrl nodes alphabetically
>>>
>>> Changes since v3:
>>>   - reordered nand
>>>   - removed ADC and USB gadget definition as they were not working. 
>>> They will
>>>     come with another set of patches adding proper support.
>>>
>>> Alexandre Belloni (8):
>>>    ARM: at91: prepare at91sam9rl DT transition
>>>    ARM: at91: Add at91sam9rl DT SoC support
>>>    ARM: at91/defconfig: Add the sam9rl to the list of DT-enabled SOCs
>>>    ARM: at91: dt: sam9rl: Device Tree for the at91sam9rlek
>>>    ARM: at91: prepare common clk transition for sam9rl SoCs
>>>    ARM: at91/dt: define at91sam9rl clocks
>>>    ARM: at91/dt: define main clk frequency of at91sam9rlek
>>>    ARM: at91: switch sam9rl to common clock framework
>>>
>>> Boris BREZILLON (1):
>>>    ARM: at91: prepare sam9 dt boards transition to common clk
>> The series seems ready for inclusion. I stack the whole series on our
>> at91-3.15-cleanup branch with my:
>>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> You can add my
>
> Acked-by: Boris BREZILLON <b.brezillon.dev@gmail>
Oops:

Acked-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>
> Thanks.
>
> Best Regards,
>
> Boris
>>
>> Thanks a lot.
>>
>>
>>>   arch/arm/boot/dts/Makefile         | 2 +
>>>   arch/arm/boot/dts/at91sam9rl.dtsi  | 802 
>>> +++++++++++++++++++++++++++++++++++++
>>>   arch/arm/boot/dts/at91sam9rlek.dts | 157 ++++++++
>>>   arch/arm/configs/at91_dt_defconfig |   1 +
>>>   arch/arm/mach-at91/Kconfig         |   1 -
>>>   arch/arm/mach-at91/at91sam9rl.c    |  23 +-
>>>   arch/arm/mach-at91/board-dt-sam9.c |  11 +-
>>>   7 files changed, 994 insertions(+), 3 deletions(-)
>>>   create mode 100644 arch/arm/boot/dts/at91sam9rl.dtsi
>>>   create mode 100644 arch/arm/boot/dts/at91sam9rlek.dts
>>>
>>
>

