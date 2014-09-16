Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaIPHXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:23:48 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:43488 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaIPHXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:23:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140915195514.GC18175@roeck-us.net>
References: <20140831175010.GA15408@roeck-us.net>
	<20140915145203.GK4659@axis.com>
	<20140915195514.GC18175@roeck-us.net>
Date: Tue, 16 Sep 2014 09:23:44 +0200
X-Google-Sender-Auth: GKZ8IgkWJcKOdQB_4q1kVpdjbhc
Message-ID: <CAMuHMdXafiDxr2QtbiuYs48BZ_wyNVFGar91oJyYvBJ+U1Co-w@mail.gmail.com>
Subject: Re: Status of 'cris' architecture support in Linux kernel
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cris <linux-cris-kernel@axis.com>, Jesper Nilsson <jespern@axis.com>,
        Mikael Starvik <starvik@axis.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Günther,

On Mon, Sep 15, 2014 at 9:55 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> > ./scripts/Makefile.headersinst:14: arch/cris/include/uapi/asm/arch-v10/Kbuild:
>> >     No such file or directory
>> > make[2]: *** No rule to make target `arch/cris/include/uapi/asm/arch-v10/Kbuild'.  Stop.
>>
>> Yes, known error, I believe that Sam Ravnborg's patch will correct this.
>>
> Is that patch available in public ? Sam's response seems to suggest that he
> sent it to Michael (Mikael ?) who wanted to handle it, but I don't find a
> matching patch in public archives.

https://lkml.org/lkml/2014/7/14/424

>> On a tangential note, my automatic (minimal) builds does not do
>> make install, so I haven't seen this error. :-P
>>
> Mine not either ;-). I only found it because I tried to build an initramfs
> which needs installed headers.

http://kisskb.ellerman.id.au/kisskb/buildresult/11881673/

We need an Auto-Builder Consolidation Project ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
