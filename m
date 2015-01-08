Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbbAHUPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 15:15:13 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47292 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbbAHUPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 15:15:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWwVmjkg-4pNvHgtBtc34+FzMKtF6e77YMqM4uRYfS+eg@mail.gmail.com>
References: <1420599537-28740-1-git-send-email-walter@vanguardiasur.com.ar>
	<1420599537-28740-2-git-send-email-walter@vanguardiasur.com.ar>
	<CAMuHMdVfqzTf034vyDPEYrnZ7+3iE+h2H+7Cs-ifJrePDrw-rg@mail.gmail.com>
	<CABxpGwDw_bE+UxypWGz3scxh3zVuxZ-1TTG2o-hEgT_mvwVatQ@mail.gmail.com>
	<CAMuHMdWwVmjkg-4pNvHgtBtc34+FzMKtF6e77YMqM4uRYfS+eg@mail.gmail.com>
Date: Thu, 8 Jan 2015 17:15:09 -0300
Message-ID: <CABxpGwCG56zmKYC8mGun9DYkgR4xS1L0F0fhF7Ze_0oHCxA4AA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input: adxl34x - add device tree documentation
From: Walter Lozano <walter@vanguardiasur.com.ar>
To: Geert Uytterhoeven <geert@linux-m68k.org>
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

On Thu, Jan 8, 2015 at 3:51 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, Jan 8, 2015 at 6:40 PM, Walter Lozano
> <walter@vanguardiasur.com.ar> wrote:
>> On Wed, Jan 7, 2015 at 6:42 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> On Wed, Jan 7, 2015 at 3:58 AM, Walter Lozano
>>> <walter@vanguardiasur.com.ar> wrote:
>>>> diff --git a/Documentation/devicetree/bindings/input/adxl34x.txt b/Documentation/devicetree/bindings/input/adxl34x.txt
>>>> new file mode 100644
>>>> index 0000000..0774f7e
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/input/adxl34x.txt
>>>> @@ -0,0 +1,53 @@
>>>> +Device Tree bindings for adxl34x digital accelerometer, both spi and i2c.
>>>> +
>>>> +Depending on the interface this node should be a child of a spi or i2c bus.
>>>> +
>>>> +Required properties:
>>>> +- compatible: "adxl34x"
>>>
>>> "adi,adxl34x"?
>>
>> Great, thanks for your feedback.
>
> BTW, did you see "[PATCH] input: adxl34x: Add OF match support"
> (http://www.spinics.net/lists/linux-i2c/msg18107.html)?

Yes, I have already seen it. Thanks for you time.

Regards,

Walter

-- 
Walter Lozano, VanguardiaSur
www.vanguardiasur.com.ar
