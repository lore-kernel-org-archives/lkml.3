Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab3KLRGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:06:54 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:62577 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab3KLRGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:06:50 -0500
MIME-Version: 1.0
In-Reply-To: <20131112153057.GA9683@earth.universe>
References: <1384265618-10590-1-git-send-email-linus.walleij@linaro.org>
	<20131112153057.GA9683@earth.universe>
Date: Tue, 12 Nov 2013 18:06:49 +0100
Message-ID: <CACRpkdb_bryGJo7CKGP5tj3RFGv=Gh+Q5m9ucVKqJ068tjPC2g@mail.gmail.com>
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

On Tue, Nov 12, 2013 at 4:30 PM, Sebastian Reichel <sre@ring0.de> wrote:
> On Tue, Nov 12, 2013 at 03:13:38PM +0100, Linus Walleij wrote:

>> +     plat->no_autorepeat = of_property_read_bool(np, "linux,no-autorepeat");
>> +     plat->enable_wakeup = of_property_read_bool(np, "linux,wakeup");
>
> There is currently discussion going on for the property name of
> autorepeat:
>
> https://lkml.org/lkml/2013/11/11/680

So this binding is documented for GPIO keys in:
Documentation/devicetree/bindings/input/gpio-matrix-keypad.txt

This is probably the most used binding as GPIO matrixes are
not uncommon. But I don't know, yes it is a mess. (As usual.)

Yours,
Linus Walleij
