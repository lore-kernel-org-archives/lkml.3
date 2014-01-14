Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaANKax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:30:53 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:36409 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaANKau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:30:50 -0500
MIME-Version: 1.0
In-Reply-To: <1389196639.23721.16.camel@hornet>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
	<1387815830-8794-4-git-send-email-pawel.moll@arm.com>
	<CACRpkdb4w26vuOtR1bAhQ6k=1uQx=np4WwoabvH8pOq8HK54=w@mail.gmail.com>
	<1389196639.23721.16.camel@hornet>
Date: Tue, 14 Jan 2014 11:30:50 +0100
Message-ID: <CACRpkdb4X+=Tpe_+U0ixyQTA3BbtX17wk=y=63CVkQsdLo60iA@mail.gmail.com>
Subject: Re: [RFC 03/18] GPIO: gpio-generic: Add label to platform data
From: Linus Walleij <linus.walleij@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>, Alexandre Courbot <gnurou@gmail.com>,
        Anton Vorontsov <anton@enomsg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 4:57 PM, Pawel Moll <pawel.moll@arm.com> wrote:
> On Mon, 2013-12-23 at 17:26 +0000, Linus Walleij wrote:

>> Good point. But what about also adding device tree support for
>> naming the chips while you're at it?
>>
>> I imagine a generic gpiochip property in
>> Documentation/devicetree/bindings/gpio/gpio.txt
>
> Well, this has been discussed almost to death already (as you may
> remember ;-) in the thread:
>
> http://www.spinics.net/lists/devicetree/msg00072.html
>
> (only portions survived)
>
> Although I was in favour of the generic binding (as were you if I
> remember correctly), the final non-conclusion was not to open the
> "generic door". Fair enough with me, I went the defined-in-code way
> here...

OK I buy this. I am willing to apply this patch. Just a problem:

Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

I can't apply this patch :-)

Please consult your fellow upstream developers on how to get
the mail out of the ARM offices in a form that I can apply...

Yours,
Linus Walleij
