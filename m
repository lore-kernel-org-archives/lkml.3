Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbbAHSvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:51:45 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:58753 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbbAHSvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:51:43 -0500
MIME-Version: 1.0
In-Reply-To: <CABxpGwDw_bE+UxypWGz3scxh3zVuxZ-1TTG2o-hEgT_mvwVatQ@mail.gmail.com>
References: <1420599537-28740-1-git-send-email-walter@vanguardiasur.com.ar>
	<1420599537-28740-2-git-send-email-walter@vanguardiasur.com.ar>
	<CAMuHMdVfqzTf034vyDPEYrnZ7+3iE+h2H+7Cs-ifJrePDrw-rg@mail.gmail.com>
	<CABxpGwDw_bE+UxypWGz3scxh3zVuxZ-1TTG2o-hEgT_mvwVatQ@mail.gmail.com>
Date: Thu, 8 Jan 2015 19:51:40 +0100
X-Google-Sender-Auth: xbsmJXPtdAYskWU3uuF92XzT5U8
Message-ID: <CAMuHMdWwVmjkg-4pNvHgtBtc34+FzMKtF6e77YMqM4uRYfS+eg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input: adxl34x - add device tree documentation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Walter Lozano <walter@vanguardiasur.com.ar>
Cc: michael.hennerich@analog.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 6:40 PM, Walter Lozano
<walter@vanguardiasur.com.ar> wrote:
> On Wed, Jan 7, 2015 at 6:42 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Wed, Jan 7, 2015 at 3:58 AM, Walter Lozano
>> <walter@vanguardiasur.com.ar> wrote:
>>> diff --git a/Documentation/devicetree/bindings/input/adxl34x.txt b/Documentation/devicetree/bindings/input/adxl34x.txt
>>> new file mode 100644
>>> index 0000000..0774f7e
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/input/adxl34x.txt
>>> @@ -0,0 +1,53 @@
>>> +Device Tree bindings for adxl34x digital accelerometer, both spi and i2c.
>>> +
>>> +Depending on the interface this node should be a child of a spi or i2c bus.
>>> +
>>> +Required properties:
>>> +- compatible: "adxl34x"
>>
>> "adi,adxl34x"?
>
> Great, thanks for your feedback.

BTW, did you see "[PATCH] input: adxl34x: Add OF match support"
(http://www.spinics.net/lists/linux-i2c/msg18107.html)?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
