Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030203Ab3AXVw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:52:57 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:40809 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638Ab3AXVwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:52:47 -0500
X-ASG-Debug-ID: 1359064366-0421b503014ebb0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 24 Jan 2013 16:52:45 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs fixes
Message-ID: <20130124215245.GG10162@shiny.int.fusionio.com>
X-ASG-Orig-Subj: Re: [GIT PULL] Btrfs fixes
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20130123004833.GA30526@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130123004833.GA30526@shiny>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1359064366
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.120805
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 05:48:33PM -0700, Chris Mason wrote:
> Hi Linus,
> 
> My for-linus branch has our batch of btrfs fixes:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> 
> We've been hammering away at a crc corruption as well, which I was
> really hoping to get into this pull.  It isn't nailed down yet, but we
> were finally able to get a solid way to reproduce.  The only good
> news is it isn't a recent regression.

Update on this, we've tracked down the crc errors and are doing final
checks on the patches.  Linus are you planning on taking this pull?  If
not I can just fold the new stuff into a bigger request.

-chris
