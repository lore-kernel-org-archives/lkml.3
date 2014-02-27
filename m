Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaB0MJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:09:20 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45383 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaB0MJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:09:19 -0500
Date: Thu, 27 Feb 2014 13:09:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL v3] liblockdep fixes for v3.14
Message-ID: <20140227120916.GA9712@gmail.com>
References: <530EAD6E.6010600@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530EAD6E.6010600@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:
> 
>   Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)
> 
> are available in the git repository at:
> 
>   https://github.com/sashalevin/liblockdep.git liblockdep-fixes
> 
> for you to fetch changes up to 7b8853419d3344b06cff64b4dc926805698eeba5:
> 
>   tools/liblockdep: Use realpath for srctree and objtree (2014-02-26 21:22:01 -0500)
> 
> ----------------------------------------------------------------
> Ira W. Snyder (3):
>       tools/liblockdep: Fix initialization code path
>       tools/liblockdep: Fix include of asm/hash.h
>       tools/liblockdep: Add include directory to allow tests to compile
> 
> Sasha Levin (2):
>       tools/liblockdep: Mark runtests.sh as executable
>       tools/liblockdep: Add a stub for new rcu_is_watching
> 
> Wang Nan (1):
>       tools/liblockdep: Use realpath for srctree and objtree
> 
>  tools/lib/lockdep/Makefile             | 6 +++---
>  tools/lib/lockdep/preload.c            | 2 +-
>  tools/lib/lockdep/run_tests.sh         | 0
>  tools/lib/lockdep/uinclude/asm/hash.h  | 6 ++++++
>  tools/lib/lockdep/uinclude/linux/rcu.h | 5 +++++
>  5 files changed, 15 insertions(+), 4 deletions(-)
>  mode change 100644 => 100755 tools/lib/lockdep/run_tests.sh
>  create mode 100644 tools/lib/lockdep/uinclude/asm/hash.h

Pulled, thanks a lot Sasha!

	Ingo
