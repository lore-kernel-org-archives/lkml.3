Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaHTTzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:55:36 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:52186 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbaHTTzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:55:35 -0400
MIME-Version: 1.0
In-Reply-To: <201408202130.28389.arnd@arndb.de>
References: <1404918119-3676-1-git-send-email-geert+renesas@glider.be>
	<CAMuHMdXp0ruZjjJLXmWyCdfAXs9_9xFHDcmJ08M9_SbZqqq04g@mail.gmail.com>
	<201408202130.28389.arnd@arndb.de>
Date: Wed, 20 Aug 2014 21:55:33 +0200
X-Google-Sender-Auth: 7rxAjPDtm6CNr4YuBA0sTXaqt-I
Message-ID: <CAMuHMdVp3xeJ2nDYJ00tLc7HuZ5v+jC-T8omWV5+G_3C8XoyoA@mail.gmail.com>
Subject: Re: [PATCH v3] arm/smp: Absorb boot_secondary()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, Aug 20, 2014 at 9:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 20 August 2014, Geert Uytterhoeven wrote:
>>
>> Ping?
>>
>> On Wed, Jul 9, 2014 at 5:01 PM, Geert Uytterhoeven
>> <geert+renesas@glider.be> wrote:
>> > After becoming a mandatory function, boot_secondary() is no longer used
>> > outside arch/arm/kernel/smp.c. Hence remove its public prototype, and,
>> > as suggested by Arnd, let it be absorbed by its single caller.
>> >
>> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> > Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> I think you should add the patch to Russell's patch tracking system
> at http://www.arm.linux.org.uk/developer/patches to get it applied.

<surprised>
Thanks for the info!
</surprised>

Has anyone already written a "git-send-email"-compatible script to
submit patches there?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
