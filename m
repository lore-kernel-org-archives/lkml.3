Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaDEA4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:56:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbaDEA4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:56:31 -0400
Date: Fri, 4 Apr 2014 20:56:24 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PULL] please pull file locking changes for 3.15
Message-ID: <20140404205624.521f67d5@ipyr.poochiereds.net>
In-Reply-To: <CA+55aFy_o-wDrbQSRnrThGqo8mcBS-pVXM6Kj0LqH8PzRr_0Kw@mail.gmail.com>
References: <20140331093120.10aeaba6@tlielax.poochiereds.net>
	<CA+55aFy_o-wDrbQSRnrThGqo8mcBS-pVXM6Kj0LqH8PzRr_0Kw@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2014 14:28:16 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Mar 31, 2014 at 6:31 AM, Jeff Layton <jlayton@redhat.com> wrote:
> > The following changes since commit 29723adee11804b548903ddb1db666cf4a60f60e:
> >
> >   locks: make locks_mandatory_area check for file-private locks (2014-03-31 08:24:43 -0400)
> >
> > are available in the git repository at:
> >
> >   git://git.samba.org/jlayton/linux.git locks-3.15
> 
> Please please please use the proper scripts (or improve on whatever
> local script you use) that show the diffstat ("git diff -M --stat
> --summary") and shortlog for the pull request too.
> 
> I want to know roughly what I'm pulling *before* I pull it, and while
> I can do a two-stage thing where I first fetch-and-inspect it, that's
> annoying. Your human-readable "Highlights" thing is good, and I want
> that too (I put commentary like that into the merge commit itself),
> but I do want that diffstat/shortlog in addition to the human-readable
> summary.
> 
> Because having the diffstat in the pull request email not only gets me
> a heasd-up abotu what to expect, it also confirms that I'm on the same
> page as you are. It acts as a sanity-check for me when I can compare
> the diffstat you *claim* I should get with the diffstat I actually get
> after merging. So I really want to get that diffstat and shortlog as a
> sanity check.
> 
> I also would prefer signed tags. It's not a must since it's not like
> git.samba.org is some random public site (I do _require_ them for pull
> requests from github etc), but it's definitely a "good thing" to have.
> 
> Anyway, I'm going through my pile of filesystem pull requests, and
> I've pulled this into my tree. I'm just going through allmodconfig
> builds etc before pushing my merge out, so assuming that all works
> fine you don't need to resend this one.  But for future pull requests,
> please do try to fix the above up.
> 
>              Linus

Thanks for the feedback and for pulling this in anyway. I'll make sure
to do all of that on subsequent pull requests.

Cheers!
-- 
Jeff Layton <jlayton@redhat.com>
