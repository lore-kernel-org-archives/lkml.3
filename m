Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3AWBk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:40:58 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:46604 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab3AWBkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:40:55 -0500
X-ASG-Debug-ID: 1358905254-03d6a508b852d4e0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Tue, 22 Jan 2013 20:40:52 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Chris Mason <clmason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs fixes
Message-ID: <20130123014052.GA32562@shiny>
X-ASG-Orig-Subj: Re: [GIT PULL] Btrfs fixes
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clmason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20130123004833.GA30526@shiny>
 <20130123012818.GA17162@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130123012818.GA17162@liubo.jp.oracle.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1358905254
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.120628
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 06:28:21PM -0700, Liu Bo wrote:
> On Tue, Jan 22, 2013 at 07:48:33PM -0500, Chris Mason wrote:
> > Hi Linus,
> > 
> > My for-linus branch has our batch of btrfs fixes:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> > 
> > We've been hammering away at a crc corruption as well, which I was
> > really hoping to get into this pull.  It isn't nailed down yet, but we
> > were finally able to get a solid way to reproduce.  The only good
> > news is it isn't a recent regression.
> > 
> > The most important batch of fixes in here come from Ilya.  They address
> > a regression Liu Bo found in the balance ioctls for pausing and resuming
> > a running balance across drives.
> > 
> > Josef's orphan truncate patch fixes an obscure corruption we'd see
> > during xfstests.
> > 
> > Arne's patches address problems with subvolume quotas.  If the user
> > destroys quota groups incorrectly the FS will refuse to mount.
> > 
> > The rest are smaller fixes and plugs for memory leaks.
> 
> Hi,
> 
> Any chance to get these in this round?  I think they're good fixes,
> a memory leak and a warning fix, both are got from xfstests.

I'll get these tested in the next pull.

-chris
