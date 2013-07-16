Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792Ab3GPWMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:12:48 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:37900 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3GPWMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:12:46 -0400
MIME-Version: 1.0
In-Reply-To: <4384290.4rZz7uttsZ@vostro.rjw.lan>
References: <20130715155202.GC29526@xanatos>
	<20130716210856.GF4994@xanatos>
	<CA+55aFwcT3pRjKKB3c+QPVZ3tREVKJwszE5EMwJ_eQTjPkOzXQ@mail.gmail.com>
	<4384290.4rZz7uttsZ@vostro.rjw.lan>
Date: Tue, 16 Jul 2013 15:12:45 -0700
X-Google-Sender-Auth: t6FNq-cSY4CTDnxXvp8eI6c7Iho
Message-ID: <CA+55aFy=XOKNePc+buJovaBu-WVUHHh=J35SSG1HyraGqH6PXQ@mail.gmail.com>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 2:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> In fact, I didn't say what I really wanted to say in that reply to the reporter
> and that evidently confused you, which only made me think it was better to be
> more careful about sending replies to regression reports when Linus is on the
> CC list.  But it was kind of fun to watch you go ballistic by mistake. ;-)

And that's why I actually mentioned in my reply to Sarah that "(in
fact, with Rafael it was at least partially just bad communication,
and I haven't had that issue with him before)", because I have this
distinct memory that we ended up having that exact discussion about
misunderstanding and bad wording at the time.

I react very strongly when somebody argues against fixing regressions.
Let's just say that there's too many years of baggage that I carry
around on that issue..

So that is definitely one of the things that make me go ballistic.
Buggy code isn't actually one of them. Bugs happen. Even really stupid
bugs happen, and happen to good people. They had a bad day, or it was
just a brainfart.  Not that I will be _polite_ about bad code, mind
you, and there might be some bad words in there, but it doesn't make
me blow up.

Being cavalier about known regressions is definitely the primary
trigger. I suspect there are others, but I can't seem to recall any
other particular hot-button issues right now. Maybe Sarah can post a
few more pointers..

              Linus
