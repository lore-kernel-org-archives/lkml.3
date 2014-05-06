Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbaEFJsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:48:01 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:49472 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934608AbaEFJsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140403110339.GD9616@pd.tnic>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
	<20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
	<CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
	<alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
	<CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
	<yw1xbnwik8go.fsf@unicorn.mansr.com>
	<20140403110339.GD9616@pd.tnic>
Date: Tue, 6 May 2014 04:47:58 -0500
Message-ID: <CAMP44s1y0X6UvG690syu3NhHOEhM70KF6mdM4tvjhZ0JTq1rtg@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 5:03 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Apr 03, 2014 at 11:34:15AM +0100, Måns Rullgård wrote:
>> Once is an accident.  Twice is incompetence.  Three times is malice.
>
> Yeah, maybe it is time Linus started his own init daemon project, like
> that other thing, git, he did start a while ago. We can put it in
> tools/. I'm sure it can get off the ground pretty quickly, judging by
> other projects kernel people have jumped on in the past.

I bet he could do it in a week and it would be better than systemd in
at least one regard: actually booting no matter what.

Maybe the next time systemd developers break things again, which is
just a matter of time.

In the meantime you want to take a look at my little init script that
implements the basics of what an init system should do[1]. You would
probably need to hack it to your needs, but since it's 230 lines of
*readable* code, that shouldn't be a problem. I also wrote a blog post
explaining the process that lad me to that code[2].

Cheers.

[1] https://github.com/felipec/finit
[2] http://felipec.wordpress.com/2013/11/04/init/

-- 
Felipe Contreras
