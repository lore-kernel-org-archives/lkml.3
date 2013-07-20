Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3GTUJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 16:09:34 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60443 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3GTUJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 16:09:32 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaJGwPLzzUuHFZye0N5iAwH2Vn8vbdwz6qv9v4F9bmGbg@mail.gmail.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E815BC@DQHE06.ent.ti.com>
	<CACRpkdaJGwPLzzUuHFZye0N5iAwH2Vn8vbdwz6qv9v4F9bmGbg@mail.gmail.com>
Date: Sat, 20 Jul 2013 22:09:32 +0200
Message-ID: <CACRpkdbsQqyA53RGs2m36Y=dh7yaXuwU8yJs=y2Dt52Pih_iLg@mail.gmail.com>
Subject: Re: [PATCH 0/3] LP3943 MFD driver for a GPIO expander and a PWM generator
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 10:04 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:

> Do you have use cases not using it for LEDs but other thing or why
> do you want to model the 16 LED lines as GPIO lines?
> Why can't you just have a drivers/leds/* as for any other LED
> chip?

Bah forget this. Now I saw that application note in the GPIO
portion patch.

But don't you want a drivers/leds/* driver for this as well?

I imagine the MFD core should send a mask to GPIO and
LEDs drivers stating which lines can be used for GPIO and
which lines can be used for LEDs.

Yours,
Linus Walleij
