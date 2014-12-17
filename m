Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaLQNQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:16:32 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38819 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaLQNQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:16:30 -0500
MIME-Version: 1.0
In-Reply-To: <4583974.6IftQ5bv2t@wuerfel>
References: <1418342706-14755-2-git-send-email-rjui@broadcom.com>
 <1628217.66frkAqHMc@wuerfel> <CAAVeFuJhiten-eVLCa2sMG-nsRwjPMiZap8UJM1kNCuRyK-b1w@mail.gmail.com>
 <4583974.6IftQ5bv2t@wuerfel>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 17 Dec 2014 22:16:09 +0900
Message-ID: <CAAVeFu+CG82UBgsQ4+RNqitUmxxaKi0P50=fjpKCqo0_ODO3jA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] gpio: Cygnus: define Broadcom Cygnus GPIO binding
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Scott Branden <sbranden@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 7:26 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 17 December 2014 11:45:01 Alexandre Courbot wrote:
>>
>> Actually we are not that far from being able to do completely without
>> any GPIO number, and maybe that's what we should aim for. I think the
>> only remaining offender is the sysfs interface. If we could reach GPIO
>> controllers through a fixed path and just export their GPIOs there, I
>> believe we would have fixed the whole issue.
>
> What about the hundreds of board files and device drivers that still
> reference hardcoded gpio numbers? The problem seems mostly solved for
> anything that uses DT, but there are some architectures and a number
> of ARM platforms that don't use DT and probably never will.
>
> I would assume they could all be changed to use gpiod_lookup tables,
> but that's a lot of work.

Indeed, that's not something to expect, as I replied to Russell. Sorry
about the confusion.
