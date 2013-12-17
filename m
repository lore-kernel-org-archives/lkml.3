Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab3LQKUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:20:11 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56989 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3LQKUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:20:08 -0500
MIME-Version: 1.0
In-Reply-To: <52ADAB0E.4020800@ti.com>
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
	<1385057731-4348-7-git-send-email-prabhakar.csengg@gmail.com>
	<52ADAB0E.4020800@ti.com>
Date: Tue, 17 Dec 2013 11:20:07 +0100
Message-ID: <CACRpkdZQ9Q1SxXZ4FPpTN_swUBCyZd8CzNzVzEm87vjYZsQ2+Q@mail.gmail.com>
Subject: Re: [PATCH v6 6/6] ARM: davinci: da850 evm: add GPIO pinumux entries
 DT node
From: Linus Walleij <linus.walleij@linaro.org>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 2:13 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On Thursday 21 November 2013 11:45 PM, Prabhakar Lad wrote:
>> From: KV Sujith <sujithkv@ti.com>

>> +
>> +                     gpio_pins: pinmux_gpio_pins {
>> +                             pinctrl-single,bits = <
>> +                                     /* GPIO2_4 GPIO2_6 */
>> +                                     0x18 0x00008080 0x0000f0f0
>> +                                     /* GPIO2_8 GPIO2_15 */
>> +                                     0x14 0x80000008 0xf000000f
>> +                                     /* GPIO3_12 GPIO3_13 */
>> +                                     0x1C 0x00008800 0x0000ff00
>> +                                     /* GPIO4_0 GPIO4_1 */
>> +                                     0x28 0x88000000 0xff000000
>> +                                     /* GPIO6_9 GPIO6_10 GPIO6_13 */
>> +                                     0x34 0x08800800 0x0ff00f00
>> +                             >;
>> +                     };
>>               };
>
> Shouldn't these pinmux entries be part of actual device
> node which needs them to be muxed this way?

The usual way to do it is to set up as states for the device,
or as a hog (on the pin controller itself).

Yours,
Linus Walleij
