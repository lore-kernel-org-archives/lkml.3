Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3CCBKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:10:32 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:51700 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3CCBKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:10:31 -0500
X-ASG-Debug-ID: 1362273030-03d6a5664a93c40001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Sat, 2 Mar 2013 20:10:28 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20130303011028.GA11322@shiny.masoncoding.com>
X-ASG-Orig-Subj: Re: [GIT PULL] Btrfs
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clmason@fusionio.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130302151535.GD28634@shiny.masoncoding.com>
 <CA+55aFy6cUszGy2=afEP5BzotFLZoH1oSi5Hjr6Kk2PkvKg_kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+55aFy6cUszGy2=afEP5BzotFLZoH1oSi5Hjr6Kk2PkvKg_kQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1362273030
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.124086
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 05:45:41PM -0700, Linus Torvalds wrote:
> On Sat, Mar 2, 2013 at 7:15 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> >
> > Our set of btrfs features, fixes and cleanups are in my for-linus
> > branch:
> 
> I *really* wish that big pull requests like this would come in earlier
> in the merge window. I hate seeing them the day before I close the
> window - really.  A number of the latter commits are done in the last
> few days, which also smells bad.

Definitely, I wanted to send this earlier in the merge window.  But I
was out last week and also didn't want to send the big stuff (raid 5/6
and the fsync work) to you right before I left on vacation.

So instead I sent things off to linux-next, and everyone on the btrfs
list collected fixes while I was gone.

-chris
