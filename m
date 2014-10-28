Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaJ1OnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:43:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:61076 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754468AbaJ1OnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:43:18 -0400
Date: Tue, 28 Oct 2014 10:43:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/7] fs: Convert show_fdinfo functions to void
Message-ID: <20141028104312.28168609@gandalf.local.home>
In-Reply-To: <1414506692.6643.2.camel@perches.com>
References: <20140929124246.3e39dac8@gandalf.local.home>
	<cover.1412031505.git.joe@perches.com>
	<e37e6e7b76acbdcc3bb4ab2a57c8f8ca1ae11b9a.1412031505.git.joe@perches.com>
	<20141028101158.3dde9880@gandalf.local.home>
	<1414506692.6643.2.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 07:31:32 -0700
Joe Perches <joe@perches.com> wrote:

 
> > I wouldn't change logic on this. There's no reason to call this
> > function if it isn't doing anything.
> > 
> > I'll change this to just do the update and not change logic like this.
> 
> Fewer #ifdefs
> 

And there's other ways to fix it (like using an #else), but that is
off-topic to the current change set. In other words, that change should
be separate, as I don't want discussions on what's the best use of
#ifdefs distracting from getting in the "void seq_printf()" changes.

-- Steve

