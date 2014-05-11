Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaEKFYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 01:24:45 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:40313 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaEKFYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 01:24:43 -0400
Date: Sun, 11 May 2014 07:24:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "S. Lockwood-Childs" <sjl@dent.vctlabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] liblockdep fixes for v3.15
Message-ID: <20140511052438.GA22436@gmail.com>
References: <536BC719.3060206@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536BC719.3060206@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:
> 
>   Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux.git liblockdep-fixes-3.15
> 
> for you to fetch changes up to ad3b564deb91c67ff9621255307ed31da870c8f7:
> 
>   tools/liblockdep: Remove all build files when doing make clean (2014-05-08 13:55:13 -0400)
> 
> ----------------------------------------------------------------
> S. Lockwood-Childs (1):
>       tools/liblockdep: Build liblockdep from tools/Makefile
> 
> Sasha Levin (1):
>       tools/liblockdep: Remove all build files when doing make clean
> 
>  tools/Makefile             | 6 ++++++
>  tools/lib/lockdep/Makefile | 5 ++---
>  2 files changed, 8 insertions(+), 3 deletions(-)

Pulled, thanks Sasha!

	Ingo
