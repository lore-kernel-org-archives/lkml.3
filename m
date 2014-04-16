Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaDPR3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:29:46 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:59380 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbaDPR3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:29:43 -0400
MIME-Version: 1.0
In-Reply-To: <1397553547.1985.25.camel@x220>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	<1391971686-9517-17-git-send-email-richard@nod.at>
	<CAF0htA5xWQwkMqdp0_zz05DLJvyCOJZf-v1Rso20de5VWFmPTA@mail.gmail.com>
	<1397553547.1985.25.camel@x220>
Date: Thu, 17 Apr 2014 01:29:41 +0800
Message-ID: <CAF0htA403PKyAgQjrMpYgawNZWKZm06UYrgV-7N_9tbas=SniA@mail.gmail.com>
Subject: Re: [PATCH 16/28] Remove GENERIC_HAS_IOMAP
From: Lennox Wu <lennox.wu@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>, Chen Liqin <liqin.linux@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pual,
OK, we will merge it into our tree.

Best,
Lennox

2014-04-15 17:19 GMT+08:00 Paul Bolle <pebolle@tiscali.nl>:
> On Mon, 2014-02-10 at 10:24 +0800, Lennox Wu wrote:
>> Thanks.
>>
>> Acked-by: Lennox Wu <lennox.wu@gmail.com>
>
> I don't think this oneliner is queued somewhere. Lennox, you're listed
> as one of the score maintainers: could you perhaps queue this patch?
>
>
> Paul Bolle
>
>> 2014-02-10 2:47 GMT+08:00 Richard Weinberger <richard@nod.at>:
>> > The symbol is an orphan, get rid of it.
>> >
>> > Signed-off-by: Richard Weinberger <richard@nod.at>
>> > ---
>> >  arch/score/Kconfig | 3 ---
>> >  1 file changed, 3 deletions(-)
>> >
>> > diff --git a/arch/score/Kconfig b/arch/score/Kconfig
>> > index c75d06a..c7a7b65 100644
>> > --- a/arch/score/Kconfig
>> > +++ b/arch/score/Kconfig
>> > @@ -23,19 +23,16 @@ config ARCH_SCORE7
>> >         bool "SCORE7 processor"
>> >         select SYS_SUPPORTS_32BIT_KERNEL
>> >         select CPU_SCORE7
>> > -       select GENERIC_HAS_IOMAP
>> >
>> >  config MACH_SPCT6600
>> >         bool "SPCT6600 series based machines"
>> >         select SYS_SUPPORTS_32BIT_KERNEL
>> >         select CPU_SCORE7
>> > -       select GENERIC_HAS_IOMAP
>> >
>> >  config SCORE_SIM
>> >         bool "Score simulator"
>> >         select SYS_SUPPORTS_32BIT_KERNEL
>> >         select CPU_SCORE7
>> > -       select GENERIC_HAS_IOMAP
>> >  endchoice
>> >
>> >  endmenu
>> > --
>> > 1.8.4.2
>
