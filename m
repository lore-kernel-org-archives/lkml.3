Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab3HQA0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:26:33 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:61846 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab3HQA03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:26:29 -0400
MIME-Version: 1.0
In-Reply-To: <5024472.WsjusA1KXL@flatron>
References: <1376387195-27469-1-git-send-email-larsi@wh2.tu-dresden.de>
	<1955836.AOXICuVgjP@flatron>
	<201308151412.43932.poeschel@lemonage.de>
	<5024472.WsjusA1KXL@flatron>
Date: Sat, 17 Aug 2013 02:26:28 +0200
Message-ID: <CACRpkda6XuZko8tF0BDYy9NuxSu5rd+b7kcB6ptUUaiv8V_2YQ@mail.gmail.com>
Subject: Re: [PATCH v2] RFC: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 2:31 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Thursday 15 of August 2013 14:12:43 Lars Poeschel wrote:

> Well, there are basically no restrictions over the format of GPIO and
> interrupt specifiers. Any driver is free to define its own and provide
> private .xlate() callback to parse it. No assumptions should be made about
> the format, other than each GPIO/interrupt is specified by numer of cells
> specified in #interrupt- or #gpio-cells property of the controller.

Surely we can assume that the binding documents can be trusted?
And for this we only need this:
Documentation/devicetree/bindings/interrupt-controller/interrupts.txt

Yours,
Linus Walleij
