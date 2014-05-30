Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbaE3Pbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:31:33 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:39341 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaE3Pbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:31:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140530152151.GR18016@ZenIV.linux.org.uk>
References: <20140529105107.GB1938@lahna.fi.intel.com>
	<20140529110439.GA2006@lahna.fi.intel.com>
	<20140529133036.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
	<20140529154454.GK18016@ZenIV.linux.org.uk>
	<20140529162307.GL18016@ZenIV.linux.org.uk>
	<CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
	<20140529165351.GM18016@ZenIV.linux.org.uk>
	<20140529185201.GN18016@ZenIV.linux.org.uk>
	<20140530081238.GA1957@lahna.fi.intel.com>
	<20140530152151.GR18016@ZenIV.linux.org.uk>
Date: Fri, 30 May 2014 08:31:30 -0700
X-Google-Sender-Auth: 6gF7be3_t-KJU1RJ-aLFGAR3yy0
Message-ID: <CA+55aFxLNvBDYtiq92DvuVqUk7byWeYiL1svbNQdXg7MRtbBcQ@mail.gmail.com>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s! [systemd-udevd:1667]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 8:21 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Linus, how would you prefer it to be handled?

I'll just have to do an rc8. I really hoped to avoid it, because we're
going on our family vacation when school is out in two weeks, and it
causes problems for the merge window, but it's not like there is much
choice - I can't do a 3.15 release with a known regression like that.

So just send me the pull request, and I'll pull it. I'll probably do
the "let's increase the x86-64 stack size to 16kB" too, to close
_that_ issue as well.

                   Linus
