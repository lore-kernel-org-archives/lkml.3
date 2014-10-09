Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbaJINjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:39:42 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35340 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaJINjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:39:33 -0400
MIME-Version: 1.0
In-Reply-To: <20141007145226.GA17925@lukather>
References: <1411746035-15882-1-git-send-email-maxime.ripard@free-electrons.com>
	<1411746035-15882-2-git-send-email-maxime.ripard@free-electrons.com>
	<7725507.nuHj4C7OxF@avalon>
	<5433D9AF.8020508@atmel.com>
	<20141007145226.GA17925@lukather>
Date: Thu, 9 Oct 2014 15:39:30 +0200
X-Google-Sender-Auth: -OBYf3ABmii4YROm0Rxqqp7PUDA
Message-ID: <CAMuHMdUKk1kJwBndjiziRexOtXV-FN7568YJ9K_ZzVecTgmbuw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Documentation: dmaengine: Add a documentation for
 the dma controller API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 4:52 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
>> >> +These various types will also affect how the source and destination
>> >> +addresses change over time, as DMA_SLAVE transfers will usually have
>> >> +one of the addresses that will increment, while the other will not,
>> >> +DMA_CYCLIC will have one address that will loop, while the other, will
>> >
>> > s/the other,/the other/
>> >
>> >> +not change, etc.
>>
>> This is a little bit vague in my opinion. And usually, it is pretty
>> implementation specific.
>
> Which is why we can't really be more precise. If you have any other
> wording coming to your mind, I'm all for it :)

Perhaps:

Addresses pointing to RAM are typically incremented (or decremented) after
each transfer. In case of a ring buffer, they may loop (DMA_CYCLIC).
Addresses pointing to a device's register (e.g. a FIFO) are typically fixed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
