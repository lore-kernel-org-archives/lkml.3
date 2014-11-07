Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaKGVuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:50:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:28323 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753083AbaKGVuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:50:04 -0500
Date: Fri, 7 Nov 2014 16:49:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Junio C Hamano <gitster@pobox.com>
Cc: Petr Mladek <pmladek@suse.cz>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 10/12 v3] seq-buf: Make seq_buf_bprintf()
 conditional on CONFIG_BINARY_PRINTF
Message-ID: <20141107164956.0a38a24d@gandalf.local.home>
In-Reply-To: <xmqqr3xeeoju.fsf@gitster.dls.corp.google.com>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.969013383@goodmis.org>
	<20141105170605.GL4570@pathway.suse.cz>
	<20141105153355.22167d0a@gandalf.local.home>
	<20141105154203.126119d8@gandalf.local.home>
	<20141106143935.GE2001@dhcp128.suse.cz>
	<xmqqr3xeeoju.fsf@gitster.dls.corp.google.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014 12:36:05 -0800
Junio C Hamano <gitster@pobox.com> wrote:

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

Yes, that's why I Cc'd you. I figured you would want to hear it.

-- Steve
