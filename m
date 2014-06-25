Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbaFYFvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:51:03 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37902 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaFYFvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:51:00 -0400
Date: Wed, 25 Jun 2014 07:50:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [GIT PULL] liblockdep fixes for v3.15
Message-ID: <20140625055054.GB7208@gmail.com>
References: <53A31A47.5010904@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A31A47.5010904@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:
> 
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux.git liblockdep-fixes
> 
> for you to fetch changes up to b2f8bdb50a426aa104f7a57ca823589869b8da6f:
> 
>   tools/liblockdep: fix comparison of a boolean value with a value of 2 (2014-06-19 13:08:10 -0400)
> 
> ----------------------------------------------------------------
> zhangdianfang (1):
>       tools/liblockdep: fix comparison of a boolean value with a value of 2
> 
>  tools/lib/lockdep/preload.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

There's a couple of problems with the commit:

 - Please capitalize the first word of the title, i.e.: "tools/liblockdep: Fix ..."

 - Commit b2f8bdb is committed by you, but not signed off by you. I 
   cannot pull SOB-less commits.

 - It's not immediately obvious from the description why the change is 
   made, please use the customary changelog style we use in the 
   kernel:

     " Current code does (A), this has a problem when (B).
       We can improve this doing (C), because (D)."

Thanks,

	Ingo
