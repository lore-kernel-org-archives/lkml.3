Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3KUWyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:54:38 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:63055 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3KUWyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:54:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311212226280.30673@ionos.tec.linutronix.de>
References: <1380893106-7550-1-git-send-email-linus.walleij@linaro.org>
	<CACRpkda6XcEA3xri116q=U26Cm3BeMWv4Us40FCyxGj3o+DAFw@mail.gmail.com>
	<alpine.DEB.2.02.1311212226280.30673@ionos.tec.linutronix.de>
Date: Thu, 21 Nov 2013 23:54:36 +0100
Message-ID: <CACRpkdYYELxiMzqmPbZNQUp0YPxOH=98-QnU2Q_JLWcGHOwTFA@mail.gmail.com>
Subject: Re: [PATCH] irqchip: versatile FPGA: support cascaded interrupts from DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 10:27 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 21 Nov 2013, Linus Walleij wrote:
>> On Fri, Oct 4, 2013 at 3:25 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>
>> > The Versatile FPGA interrupt controller supports cascading interrupts,
>> > i.e. that its output is connected to the input of another interrupt
>> > controller. This makes it possible to pass a parent interrupt from
>> > the device tree and print it in the boot log if applicable.
>> >
>> > Cc: Thomas Gleixner <tglx@linutronix.de>
>> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> > ---
>> > TGLX: I can take this through ARM SoC if you're happy with it
>> > and prefer it that way, but it merges just as fine as it is on
>> > the IRQ tree.
>>
>> Ping on this!
>
> by all means, I can't find the original patch anywhere in my mail
> folders. Can you bounce it to me please?

Hm it is not in the marc archives either, what is this now..

Anyway I've resent it.

Yours,
Linus Walleij
