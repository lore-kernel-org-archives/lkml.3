Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab3JKQVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:21:47 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64254 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab3JKQVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:21:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+V-a8vH7VXqz=2cz-uD=YfRBRYrJ10K1Aptw28vV8gP+PiT2g@mail.gmail.com>
References: <1380902596-4693-1-git-send-email-sujithkv@ti.com>
	<1380902596-4693-2-git-send-email-sujithkv@ti.com>
	<CACRpkdYxegBSYXR1-98smUNnDXpyRHo_vuYdnr3r7zhawENiUA@mail.gmail.com>
	<CA+V-a8vyPyL0j0nPOZyjxrecusFzXovFPsNBLKYXns5ASWR-wg@mail.gmail.com>
	<CACRpkdYNexWWXuQ052xuQ4NOdXm2gt-+ByREKeGo-VAnbH4D2w@mail.gmail.com>
	<CA+V-a8vH7VXqz=2cz-uD=YfRBRYrJ10K1Aptw28vV8gP+PiT2g@mail.gmail.com>
Date: Fri, 11 Oct 2013 18:21:44 +0200
Message-ID: <CACRpkdYSCgs9eiN4crqXYQrbU71H-6-u04C2a5OeHHu4Da3big@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] gpio: davinci: add OF support
From: Linus Walleij <linus.walleij@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 6:18 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> On 10/11/13, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Fri, Oct 11, 2013 at 4:59 PM, Prabhakar Lad
>> <prabhakar.csengg@gmail.com> wrote:
>>> On 10/11/13, Linus Walleij <linus.walleij@linaro.org> wrote:
>>>> On Fri, Oct 4, 2013 at 6:03 PM, Prabhakar Lad
>>>> <prabhakar.csengg@gmail.com> wrote:
>>
>>>>> +- ti,davinci-gpio-irq-base: Base from where GPIO interrupt numbering
>>>>> starts.
>>>>
>>>> What is this?
>>>>
>>>> If I have ever ACKed this I have been drunk. I take it back.
>>>>
>>> here is the ACK https://patchwork.kernel.org/patch/2721181/
>>
>> And as suspected that version of the patch did not contain
>> this strange node property.
>>
> The property did exist in the patch 'intc_irq_num', I just renamed
> it and gave a proper description to it.

Hm yeah you're right ... I didn't understand what it was actually
doing until I saw the revised documentation, I though it was
stating the number of (hardware) IRQs, but it was stating the
Linux-internal offset.

Yours,
Linus Walleij
