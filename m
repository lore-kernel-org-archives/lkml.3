Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3HaGot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 02:44:49 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49175 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3HaGoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 02:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130830193740.GA13101@roeck-us.net>
References: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
	<20130830184611.GA27455@spo001.leaseweb.com>
	<20130830191146.GA12090@roeck-us.net>
	<CA+55aFyxHsKhtqqz9jTDYo89bCNqCWhjHGJ4HzFrHnJ0yxLXjQ@mail.gmail.com>
	<20130830193740.GA13101@roeck-us.net>
Date: Sat, 31 Aug 2013 08:44:45 +0200
X-Google-Sender-Auth: IY0VvW5uPoIvwFOEcqczk_abxd0
Message-ID: <CAMuHMdW6KcHbpR_KzbTg9V_FJ8XvQAWQOB-2jXQxG5fo1wWg1A@mail.gmail.com>
Subject: Re: [PATCH 0/7] Drop support for Renesys H8/300 architecture
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 9:37 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Fri, Aug 30, 2013 at 12:14:20PM -0700, Linus Torvalds wrote:
>> On Fri, Aug 30, 2013 at 12:11 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> >
>> > I would not mind if Linus would agree to pull it right away for 3.12,
>> > but that seems to be a bit on the fast side.
>>
>> I'm ok with code deletion patches, I don't think that would be a
>> problem. I didn't check them, but I assume this is all literally just
>> removing code that is conditional on h8/300 config options?
>>
> Yes.
>
> I found a couple more since I sent the series, but nothing significant.
>
> What is your preference - keep it until 3.13, or prepare it now and send you
> a pull request for 3.12 ?

It would be nice to check with Sato-san, who wanted to attend Kernel
Summit as a hobbyist architecture maintainer, and see what are his plans
and opinions.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
