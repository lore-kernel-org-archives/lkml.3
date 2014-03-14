Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaCNLCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:02:05 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:56372 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbaCNLCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:02:03 -0400
MIME-Version: 1.0
In-Reply-To: <5322D529.4070904@ahsoftware.de>
References: <5316FFCE.1060603@ti.com>
	<1394018461-757-1-git-send-email-holler@ahsoftware.de>
	<CACRpkdaF=jc9Z1XZCtH8VPuih01t--qyV-sgH1R_ix0VM4RzVA@mail.gmail.com>
	<5322D529.4070904@ahsoftware.de>
Date: Fri, 14 Mar 2014 12:02:01 +0100
Message-ID: <CACRpkdaghneo1MvNCfxjTED+sJepHgeZCgmKsRteG9qrBNWAfQ@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: davinci: fix gpio selection for OF
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 11:08 AM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 11.03.2014 11:15, schrieb Linus Walleij:
>> On Wed, Mar 5, 2014 at 12:21 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>>
>>> The driver missed an of_xlate function to translate gpio numbers
>>> as found in the DT to the correct chip and number.
>>>
>>> While there I've set #gpio_cells to a fixed value of 2.
>>>
>>> I've used gpio-pxa.c as template for those changes and tested my changes
>>> successfully on a da850 board using entries for gpio-leds in a DT. So I didn't
>>> reinvent the wheel but just copied and tested stuff.
>>>
>>> Thanks to Grygorii Strashko for the hint to the existing code in gpio-pxa.
>>>
>>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> This v2 version applied, thanks!
>
> Thanks, but actually that should have been a fix for 3.14 with which the
> OF functionality for davinci gpio gets introduced. I assum with the
> patch in for-next, 3.14 will appear with that functionality broken and
> it will become a candidate for -stable.

I just get the impression that DT support for DaVinci in v3.14 is so risky
and unstable that noone except those implementing it (i.e. you) is really
using it, is that correct?

In that case it is hardly a fix that we need to rush out to the entire world.

But if you have bug reports from DaVinci developers doing advanced DT
stuff and scratching their heads, then we can push this to fixes.

Yours,
Linus Walleij
