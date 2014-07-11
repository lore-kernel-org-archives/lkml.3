Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaGKQYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:24:54 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:41696 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbaGKQYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140711162153.GV20603@laptop.programming.kicks-ass.net>
References: <20140711161341.GF12054@laptop.lan>
	<CAMuHMdWj=aJsxZJPM=v-z8+=yTAopPWYe5T-+ovnnuEydFuGvA@mail.gmail.com>
	<20140711162153.GV20603@laptop.programming.kicks-ass.net>
Date: Fri, 11 Jul 2014 18:24:49 +0200
X-Google-Sender-Auth: CLYZoYwEp8PXtYvtbLQutv_Inwg
Message-ID: <CAMuHMdXinJz2OWXvyfxWVssEwDMWyYP_rV6db=ZePnLz2B9YoA@mail.gmail.com>
Subject: Re: [PATCH] Remove soon to be dead email address
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jbaron@akamai.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Jul 11, 2014 at 6:21 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jul 11, 2014 at 06:17:31PM +0200, Geert Uytterhoeven wrote:
>> On Fri, Jul 11, 2014 at 6:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > My Red Hat email address will soon cease to be; remove it from the
>> > tree in order to save the interweb some bounces.
>>
>> > --- a/include/linux/jump_label.h
>> > +++ b/include/linux/jump_label.h
>> > @@ -4,8 +4,8 @@
>> >  /*
>> >   * Jump label support
>> >   *
>> > - * Copyright (C) 2009-2012 Jason Baron <jbaron@redhat.com>
>> > - * Copyright (C) 2011-2012 Peter Zijlstra <pzijlstr@redhat.com>
>> > + * Copyright (C) 2009-2012 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
>>
>> Change not mentioned in comment (there are a few more of these).
>>
>> > + * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra
>
> Oh, right.. my bad. I should also have Cc'ed Jason I suppose.
>
> The thing is, those were copyright RedHat (implicitly by the @redhat and
> my copyright assingment to employer at the time etc..) But if I remove
> the email address there is nothing that reflects that.

Sure, the changes for lines with your name were implied by dropping the
email address.

> The same is true for Jason, but let me copy him.

That's the one I meant.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
