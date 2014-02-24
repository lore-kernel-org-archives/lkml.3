Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaBXNkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:40:25 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39681 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaBXNkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:40:24 -0500
MIME-Version: 1.0
In-Reply-To: <201402141754.02159.arnd@arndb.de>
References: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
	<20140213131720.GC3403@lee--X1>
	<CACRpkdaoqwiy0n-oN0gKqgX_enGXw+BggRQy9yz8eQNyJ3MvsA@mail.gmail.com>
	<201402141754.02159.arnd@arndb.de>
Date: Mon, 24 Feb 2014 14:40:23 +0100
Message-ID: <CACRpkdYTd+x=tEviRxXv6HANscJjWqfeVOhDtpefFmxiuCsVDw@mail.gmail.com>
Subject: Re: [PATCH] mfd: dbx500/abx500: root out hardcoded IRQ assignments
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 5:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 14 February 2014, Linus Walleij wrote:

>> > I'm happy to do either, but the latter will require an ARM-SoC Ack.
>>
>> OK Olof/Arnd/Kevin: can you ACK this patch for queueing
>> through MFD? It only hits arch/arm/mach-ux500/*
>
> Sounds good. Great job at cleaning up that stuff!

Lee this sounds like an ACK :-)

Please queue this patch, I will probably avoid doing more
of this stuff for the next merge window so I think it won't
collide with anything.

Yours,
Linus Walleij
