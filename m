Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626AbaEFJfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:35:52 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49633 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934526AbaEFJfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:35:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140403180644.GD21565@kroah.com>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
	<yw1x7g76k62z.fsf@unicorn.mansr.com>
	<CA+bK7J57f8mHC0=UWrFG1MyyURb2hU6p2K1RTsHoWRNUz9LWLw@mail.gmail.com>
	<20140403180644.GD21565@kroah.com>
Date: Tue, 6 May 2014 04:35:35 -0500
Message-ID: <CAMP44s3BeUSBqTm=nJbcOnNqZuqBX3q1O47645LV_wgvbV2TgA@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tim Bird <tbird20d@gmail.com>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 12:06 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Apr 03, 2014 at 08:17:33AM -0700, Tim Bird wrote:
>>
>> I had no idea systemd was so verbose and was abusing the kernel
>> log buffers so badly.  I'm not a big fan of the rate-limiting, as this just
>> seems to encourage this kind of abuse.
>
> That was a bug in systemd, and has been fixed up in the latest versions,
> so it shouldn't happen anymore, even with debugging enabled.

Excellent. Did Kay Sievers accept it was a bug? From what I can see
the bug report is still open[1], and your patch to rename the
configuration to systemd.debug received unanimous consensus in the
mailing list, yet it wasn't applied.

So I bet the answer is no, he never accepted it, and we should expect
these issues to continue... it's only a matter of time before we hit
the next breakage.

[1] https://bugs.freedesktop.org/show_bug.cgi?id=76935

-- 
Felipe Contreras
