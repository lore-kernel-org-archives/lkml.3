Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584Ab3AQKax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:30:53 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40020 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759570Ab3AQKat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:30:49 -0500
MIME-Version: 1.0
In-Reply-To: <50ED66F2.8050006@ti.com>
References: <1357633220-29827-1-git-send-email-anilkumar.v@ti.com>
	<1357633220-29827-4-git-send-email-anilkumar.v@ti.com>
	<50ED66F2.8050006@ti.com>
Date: Thu, 17 Jan 2013 11:30:48 +0100
Message-ID: <CACRpkdajc7e00EdgnYD_7ucOMDFhqx53EvN3uEzJ1pQhHazr9Q@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] ARM: davinci: da850: add NAND driver entries
From: Linus Walleij <linus.walleij@linaro.org>
To: Sekhar Nori <nsekhar@ti.com>
Cc: "Kumar, Anil" <anilkumar.v@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        Kevin Hilman <khilman@deeprootsystems.com>, hs@denx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 1:47 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 1/8/2013 1:50 PM, Kumar, Anil wrote:

>> +&pmx_core{
>> +     pinctrl-names = "default";
>> +     pinctrl-0 = <
>> +             &nand_cs3_pins
>> +     >;
>
> This means that the NAND pins are configured even if NAND is not
> probed. Right? This can be moved into the nand_cs3 node to avoid that.
> And then when used with Linus Walleij's patch "drivers/pinctrl: grab
> default handles from device core" which should be accepted soon, the
> pins will be automatically setup when the NAND gets probed.

That is correct, I am waiting for Greg's ACK on the core grab patch
(maybe it's higher up in my mailbox) and some indication from Stephen
Warren that it doesn't break the Tegra, and I'll put it into linux-next.

Yours,
Linus Walleij
