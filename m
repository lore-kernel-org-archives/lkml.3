Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086AbaLUFJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 00:09:11 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:49889 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaLUFJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 00:09:09 -0500
Date: Sat, 20 Dec 2014 21:08:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.19-rc1 - merge window closed
Message-ID: <20141221050854.GA23583@roeck-us.net>
References: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.549655FD.006F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 05:43:22PM -0800, Linus Torvalds wrote:
> So it's been a day less than two weeks, and the merge window is closed.
> 
> Considering how much came in fairly late, I find it hard to care about
> anybody who had decided to cut it even closer than some people already
> did.   That said, maybe there aren't any real stragglers - and judging
> by the size of rc1, there really can't have been much. Not only do I
> think there are more commits than there were in linux-next, this is
> one of the bigger rc1's (at least by commits) historically. We've had
> bigger ones (3.10 and 3.15 both had large merge windows leading up to
> them), but this was definitely not a small merge window.
> 
> Anyway, we've got changes all over the place, including a new
> architecture (nios2). My "short mergelog" is appended, and as usual I
> want to point out that that credits the people sending me the changes,
> which is generally not necessarily at all the same thing as the people
> actually writing the code, even if there is obviously overlap.
> 
> In the "big picture", this looks like a fairly normal release. About
> two thirds driver updates, with about half of the rest being
> architecture updates (and no, the new nios2 patches are not at all
> dominant, it's about half ARM, with  the new nios2 support being less
> than 10% of the arch updates by lines overall). The remaining one
> sixth is "misc": networking, header updates, documentation,
> filesystems, tooling, and core kernel (in pretty much that order).
> 
> Obviously, with the holidays coming up, I'd expect that the next few
> weeks are pretty quiet, but we'll see. I do hope that people will have
> time to test this all in between all the eggnog,
> 

There are at least the never-resting auto-testers, which for mine report:

Build tests:
	total: 133 pass: 133 fail: 0

Qemu tests:
	total: 30 pass: 30 fail: 0

Details at http://server.roeck-us.net:8010/builders.

This is an absolute first; since I started testing, we never had an
-rc1 with no build or qemu failures. Excellent job everyone!

Guenter
