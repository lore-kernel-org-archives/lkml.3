Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaLWJ3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 04:29:19 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44747 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaLWJ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:29:16 -0500
Date: Tue, 23 Dec 2014 10:29:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Kirill Smelkov <kirr@nexedi.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] liblockdep fixes for v3.19
Message-ID: <20141223092911.GA9246@gmail.com>
References: <549781C3.50407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549781C3.50407@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> Hi Ingo,
> 
> A small (but important) fix to the way we detect freeing live locks. We would
> pass a wrong memory region when testing for locks inside freed memory spaces,
> which would trigger false positives.
> 
> 
> Thanks,
> Sasha
> 
> The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:
> 
>   Linux 3.18 (2014-12-07 14:21:05 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux.git liblockdep-fixes-3.19
> 
> for you to fetch changes up to 95bfdf23e4d59099340c01064f39e7f6875c02bc:
> 
>   tools/liblockdep: Fix debug_check thinko in mutex destroy (2014-12-19 15:50:55 -0500)
> 
> ----------------------------------------------------------------
> Kirill Smelkov (1):
>       tools/liblockdep: Fix debug_check thinko in mutex destroy
> 
>  tools/lib/lockdep/preload.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Pulled, thanks Sasha!

	Ingo
