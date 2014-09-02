Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaIBNHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:07:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaIBNHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:07:23 -0400
Date: Tue, 2 Sep 2014 15:04:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Vishnu Pratap Singh <vishnu.ps@samsung.com>, akpm@linux-foundation.org,
        richard@nod.at, paulmck@linux.vnet.ibm.com, fabf@skynet.be,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        cpgs@samsung.com, pintu.k@samsung.com, vishu13285@gmail.com
Subject: Re: [PATCH] kernel/signal.c: whitespace fixes
Message-ID: <20140902130430.GA20751@redhat.com>
References: <1409661657-7598-1-git-send-email-vishnu.ps@samsung.com> <alpine.LNX.2.00.1409021445580.2481@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1409021445580.2481@pobox.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02, Jiri Kosina wrote:
>
> On Tue, 2 Sep 2014, Vishnu Pratap Singh wrote:
>
> > From: "vishnu.ps" <vishnu.ps@samsung.com>
> >
> > Fix minor errors and warning messages in kernel/signal.c.  These errors were
> > reported by checkpatch while working with some modifications in signal.c
> > file.
> >
> > ERROR: code indent should use tabs where possible - 18
> > ERROR: need consistent spacing around '&' (ctx:WxO) - 11
> > ERROR: space prohibited after that '~' (ctx:OxW) - 11
> > ERROR: trailing whitespace - 4
> > ERROR: space required after that ',' (ctx:VxV) - 4
> > ERROR: trailing statements should be on next line - 3
> > ERROR: "foo * bar" should be "foo *bar" - 1
> >
> > total 52 errors fixed.
>
> I am not taking this through trivial.git; it just clutters results of 'git
> blame' horribly for no measurable gain.
>
> Changes like this are reasonable only if you make any real changes to the
> code at the same time.

I agree very much.

Vishnu, please think about those (me in particular ;) who need to backport
the fixes from time to time. Just suppose we have a bug in, say,
do_notify_parent_cldstop(), and it is fixed later. Now I will likely need
to backport your change too, and this is not trivial in general, plus this
adds the additional risk.

Oleg.

