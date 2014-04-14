Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaDNLYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:24:18 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61579 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbaDNLYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:24:16 -0400
Date: Mon, 14 Apr 2014 13:24:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] liblockdep fixes for v3.15
Message-ID: <20140414112412.GB4050@gmail.com>
References: <533D7A4D.3090900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533D7A4D.3090900@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> Hi Ingo,
> 
> There are two patches from liblockdep this time around:
> 
>  1. There was a build breakage caused by marking a function 'asmlinkage'
> in lockdep.h. Fix that by ignoring asmlinkage and visible annotations.
> 
>  2. Josh Boyer mentioned that Fedora would like to include liblockdep
> as a package, so we had to fix our versioning methods from being dumb
> and pointless to something actually usable. So now liblockdep.so tracks
> the kernel version which makes lives of distro folks much easier.
> 
> ==
> 
> The following changes since commit 01d5f3b598b18a5035426c30801adf65822dbd0c:
> 
>   Merge branch 'for-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata (2014-03-31 15:27:37 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux.git liblockdep-fixes
> 
> for you to fetch changes up to be227b45fb228adff4371b8de9e3989904209ff4:
> 
>   tools/liblockdep: Add proper versioning to the shared obj (2014-04-01 11:46:10 -0400)
> 
> ----------------------------------------------------------------
> Sasha Levin (2):
>       tools/liblockdep: Ignore asmlinkage and visible
>       tools/liblockdep: Add proper versioning to the shared obj
> 
>  tools/lib/lockdep/Makefile                 | 15 ++++-----------
>  tools/lib/lockdep/uinclude/linux/lockdep.h |  3 +++
>  2 files changed, 7 insertions(+), 11 deletions(-)

Pulled, thanks Sasha!

	Ingo
