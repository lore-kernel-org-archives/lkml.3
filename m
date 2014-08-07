Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbaHGN2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:28:34 -0400
Received: from imap.thunk.org ([74.207.234.97]:48685 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbaHGN2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:28:33 -0400
Date: Thu, 7 Aug 2014 09:28:23 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
Message-ID: <20140807132823.GB32722@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
 <20140806144643.45e5dab8@canb.auug.org.au>
 <87lhr2tcyx.fsf@x220.int.ebiederm.org>
 <20140806160608.218b6944@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806160608.218b6944@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 04:06:08PM +1000, Stephen Rothwell wrote:
> 
> Yes, that is what confused my, sorry, since that commit and the ones
> following are new commits but unchanged patches.

As a suggestion, in addition to trying to count the number of commits
that are new, or with the same patch id's, etc., is to provide the
diff stats between the last version of the branch that landed in
linux-next before the merge window opened, and the branch head that
was requested for Linus to pull?

This will get tripped up by those poeple who send multiple pull
requests which are subsets of the branch that is tracked by linux-next
(for example, to arrange the order of merging to minimize conflicts),
so like all things, it's not perfect, but it might be useful
additional indicator, at least in the early days of the merge window.

Also, if you could report the commit id of the branch head before the
merge window opened, then other people (including Linus) can do their
own investigation and draw their own conclusions.

Cheers,

						- Ted

P.S.  If there was some way this could be automated so that a 'bot
sends out a report for every single pull request, then it minimizes
the "J'accuse!" aspect, since the report is being done for all pull
requests, and everyone knows that robots makes mistakes.  :-)
