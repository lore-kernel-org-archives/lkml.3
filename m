Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaIGCaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 22:30:09 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37808 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaIGCaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 22:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <2954780.2t9bpyu7ov@wuerfel>
References: <1409959394-14936-1-git-send-email-behanw@converseincode.com>
	<2954780.2t9bpyu7ov@wuerfel>
Date: Sat, 6 Sep 2014 19:30:06 -0700
Message-ID: <CAFzeTN0AO40k2ObpMX3xPOmKaiGdiLREev1A2J0sE=B7z64qug@mail.gmail.com>
Subject: Re: [PATCH] arm64: LLVMLinux: Provide __aeabi_* symbols which are
 needed for clang
From: Mark Charlebois <charlebm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Behan Webster <behanw@converseincode.com>, catalin.marinas@arm.com,
        will.deacon@arm.com, zhichang.yuan@linaro.org, dsaxena@linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2014 at 7:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Friday 05 September 2014 16:23:14 behanw@converseincode.com wrote:
> > --- /dev/null
> > +++ b/arch/arm64/lib/eabi.c
> > @@ -0,0 +1,32 @@
> > +/*
> > + *  linux/lib/eabi.c
>
> Please don't put the file names in the files themselves, it's redundant
> and in this case actually wrong.

Sorry, will fix.

>
> > + *  Copyright (C) 2012  Mark Charlebois
> > + */
> > +
> > +/*
> > + * EABI routines
>
> Does EABI specify these function names? I would think that they are
> just random libgcc (whatever that is called in clang) functions.

http://infocenter.arm.com/help/topic/com.arm.doc.ihi0043d/IHI0043D_rtabi.pdf

See section 4.3.4 Memory copying, clearing, and setting

>
>         Arnd
