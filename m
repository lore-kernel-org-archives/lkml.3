Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbaGPLx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:53:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60690 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbaGPLx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:53:56 -0400
Date: Wed, 16 Jul 2014 13:53:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "S. Lockwood-Childs" <sjl@dent.vctlabs.com>,
        zhangdianfang <zhangdianfang@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL v2] liblockdep fixes for v3.15
Message-ID: <20140716115345.GD28434@gmail.com>
References: <53BACA23.9010907@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BACA23.9010907@oracle.com>
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
> for you to fetch changes up to b10827814e9c81c5a14fb73c5a6e06bd85df3f94:
> 
>   tools/liblockdep: Account for bitfield changes in lockdeps lock_acquire (2014-07-07 12:20:16 -0400)
> 
> ----------------------------------------------------------------
> S. Lockwood-Childs (1):
>       tools/liblockdep: Account for bitfield changes in lockdeps lock_acquire
> 
> Sasha Levin (1):
>       tools/liblockdep: Remove debug print left over from development
> 
> zhangdianfang (1):
>       tools/liblockdep: Fix comparison of a boolean value with a value of 2
> 
>  tools/lib/lockdep/include/liblockdep/mutex.h  |  4 ++--
>  tools/lib/lockdep/include/liblockdep/rwlock.h |  8 ++++----
>  tools/lib/lockdep/preload.c                   | 20 +++++++++-----------
>  3 files changed, 15 insertions(+), 17 deletions(-)

Pulled, thanks Sasha!

	Ingo
