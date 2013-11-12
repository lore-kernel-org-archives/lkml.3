Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3KLULt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:11:49 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:48518 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3KLULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:11:41 -0500
MIME-Version: 1.0
In-Reply-To: <20131112200514.GA15413@earth.universe>
References: <1384265618-10590-1-git-send-email-linus.walleij@linaro.org>
	<20131112153057.GA9683@earth.universe>
	<CACRpkdb_bryGJo7CKGP5tj3RFGv=Gh+Q5m9ucVKqJ068tjPC2g@mail.gmail.com>
	<20131112200514.GA15413@earth.universe>
Date: Tue, 12 Nov 2013 21:11:40 +0100
Message-ID: <CACRpkdaAaLjm_b+OLj3tobxBN8YGUcTPnXJ=qtBqd02=FTxhjQ@mail.gmail.com>
Subject: Re: [PATCH 4/5 v2] input: tc3589x-keypad: support probing from device tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 9:05 PM, Sebastian Reichel <sre@ring0.de> wrote:
> On Tue, Nov 12, 2013 at 06:06:49PM +0100, Linus Walleij wrote:

>> So this binding is documented for GPIO keys in:
>> Documentation/devicetree/bindings/input/gpio-matrix-keypad.txt
>>
>> This is probably the most used binding as GPIO matrixes are
>> not uncommon. But I don't know, yes it is a mess. (As usual.)
>
> I could find two boards using "gpio-matrix-keypad" in the mainline
> kernel and not a single instance of "linux,no-autorepeat":

In things connected to GPIO, I don't expect the in-kernel
device trees to be a good way so survey the usage of these
bindings. Anyone doing device trees on any system with a
few GPIOs can be using this.

But maybe we're lucky and won't break anyone's setup if
we change this?

Yours,
Linus Walleij
