Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaDFRVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 13:21:07 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33821 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbaDFRUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 13:20:48 -0400
Date: Sun, 6 Apr 2014 18:19:37 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
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
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140406181937.0cd6298b@alan.etchedpixels.co.uk>
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
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2014 13:03:39 +0200
Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Apr 03, 2014 at 11:34:15AM +0100, Måns Rullgård wrote:
> > Once is an accident.  Twice is incompetence.  Three times is malice.
> 
> Yeah, maybe it is time Linus started his own init daemon project, like
> that other thing, git, he did start a while ago. We can put it in
> tools/. I'm sure it can get off the ground pretty quickly, judging by
> other projects kernel people have jumped on in the past.
> 

We have a perfectly good, dependancy understanding, self ordering,
paralleising startup, service level and event management tool.

Its called "make"

We shipped devices using it about fifteen years ago 8)

Alan
