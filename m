Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaKJSn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:43:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaKJSn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:43:28 -0500
Date: Mon, 10 Nov 2014 19:43:20 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Junio C Hamano <gitster@pobox.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 10/12 v3] seq-buf: Make seq_buf_bprintf()
 conditional on CONFIG_BINARY_PRINTF
Message-ID: <20141110184319.GB2552@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.969013383@goodmis.org>
 <20141105170605.GL4570@pathway.suse.cz>
 <20141105153355.22167d0a@gandalf.local.home>
 <20141105154203.126119d8@gandalf.local.home>
 <20141106143935.GE2001@dhcp128.suse.cz>
 <xmqqr3xeeoju.fsf@gitster.dls.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xmqqr3xeeoju.fsf@gitster.dls.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-07 12:36:05, Junio C Hamano wrote:
> Petr Mladek <pmladek@suse.cz> writes:
> 
> > On Wed 2014-11-05 15:42:03, Steven Rostedt wrote:
> > ...
> >> 
> >> OK, 'git rebase' is SUPER AWESOME!!!
> >> 
> >> I just did a git rebase, moved this change to before the file move, and
> >> git somehow knew that the change was for the old file, and updated it
> >> without any modification from me. The rebase simply succeeded!
> >> 
> >> I checked, the change still changed seq_buf.c, but in the
> >> old kernel/trace directory.
> >
> > That is really awesome! Dreams become reality.
> 
> It is rare to hear somebody talks about Git without having "sucks"
> in the same sentence ;-)

This might be an effect of bugzilla and other bugreport tools. One
gets the feeling that there are only people strugling with the software.
In fact, there is usually much bigger group of happy users. They
just keep the happines inside until something goes wrong :-)

I am happy git user (most of the time :-)

Best Regards,
Petr
