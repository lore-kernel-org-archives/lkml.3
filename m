Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaBXKUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:20:44 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:53200 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaBXKUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:20:42 -0500
Message-ID: <530B1CF4.2060208@gmail.com>
Date: Mon, 24 Feb 2014 11:20:36 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from
 Dove pinctrl
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com> <CACRpkdZ1JR82m46YV5m=b6e3E3OYcNCka_8EiT2VcSPU=ZVLdQ@mail.gmail.com>
In-Reply-To: <CACRpkdZ1JR82m46YV5m=b6e3E3OYcNCka_8EiT2VcSPU=ZVLdQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/14 11:17, Linus Walleij wrote:
> On Mon, Feb 24, 2014 at 9:42 AM, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com> wrote:
>
>> This is a patches separated from one sent earlier [1] with just the
>> removal of any hard-coded reg addresses from Dove pinctrl stub.
>
> OK let's queue this a while later on top of the other stuff (that I'm working
> on applying right now).

Ok.

>> In the meantime, support for new Armada 375/38x was added that also
>> contain patches for pinctrl [2].
>
> I applied these first. Please look at the result once I push out the
> pinctrl tree with the 375/38x + your v4 series in combination
> (let's see how big mess it will be...)
>
> I'm sorry for not applying the nice patches earlier, forcing you to work
> on many parallel series like this, hopefully I'll be able to attend to
> them this week.

It's okay, I don't expect you to jump on every patch set we sent
immediately.

Although, I guess instead of applying them separately, it would have
been better to pull them from Jason's stable topic branch. But that is
also up to you and Jason may give valuable hints on how to proceed in
the future.

Thanks anyway!

Sebastian
