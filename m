Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaBNKqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:46:43 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62425 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBNKqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:46:42 -0500
MIME-Version: 1.0
In-Reply-To: <20140213131720.GC3403@lee--X1>
References: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
	<CACRpkdYnw3S3YEa8b0Pmipp892unBhVBMs0kqSNBAz5i0CVA0g@mail.gmail.com>
	<20140213131720.GC3403@lee--X1>
Date: Fri, 14 Feb 2014 11:46:41 +0100
Message-ID: <CACRpkdaoqwiy0n-oN0gKqgX_enGXw+BggRQy9yz8eQNyJ3MvsA@mail.gmail.com>
Subject: Re: [PATCH] mfd: dbx500/abx500: root out hardcoded IRQ assignments
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, "arm@kernel.org" <arm@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 2:17 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> <linus.walleij@linaro.org> wrote:
>>
>> > The DBx500 and ABx500 should be getting their IRQs from the
>> > device tree and nowhere else. Get rid of all the static assignments
>> > everywhere, delete it from the driver, platform data and the
>> > board files in one swift strike.
>> >
>> > Lots of cross-dependencies in the MFD drivers for PRCMU and
>> > AB8500 makes it necessary to strike everywhere at once to
>> > eradicate IRQs passed as resources and platform data to the left
>> > and right around the platform.
>> >
>> > Cc: Mark Brown <broonie@kernel.org>
>> > Cc: Samuel Ortiz <sameo@linux.intel.com>
>> > Cc: Lee Jones <lee.jones@linaro.org>
>> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> OK no major complaints, Lee can you queue this in the MFD tree
>> so we get some Linux-next rotation? If we need an immutable
>> branch remains to be seen, maybe we can merge this throug MFD
>> exclusively.
>
> I'm happy to do either, but the latter will require an ARM-SoC Ack.

OK Olof/Arnd/Kevin: can you ACK this patch for queueing
through MFD? It only hits arch/arm/mach-ux500/*

Yours,
Linus Walleij
