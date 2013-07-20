Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3GTUEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 16:04:16 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62997 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3GTUEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 16:04:15 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E815BC@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E815BC@DQHE06.ent.ti.com>
Date: Sat, 20 Jul 2013 22:04:13 +0200
Message-ID: <CACRpkdaJGwPLzzUuHFZye0N5iAwH2Vn8vbdwz6qv9v4F9bmGbg@mail.gmail.com>
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

On Tue, Jul 16, 2013 at 4:38 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> LP3943 is an integrated device capable of driving 16 output channels.
> It supports a GPIO expander and a PWM generator.

But actually the data sheet describes it as a LED driver with PWM
chip.

Do you have use cases not using it for LEDs but other thing or why
do you want to model the 16 LED lines as GPIO lines?
Why can't you just have a drivers/leds/* as for any other LED
chip?

Atleast some good explanation of this needs to be found in the
patch text and also as comments in Kconfig and the code I think.

I'm just fearing that this is some way to satisfy a userspace that
wants to use the sysfs interface to GPIO to control LEDs and these
are much better off using the LED sysfs ABI.

Yours,
Linus Walleij
