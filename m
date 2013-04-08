Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935322Ab3DHJog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:44:36 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53661 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab3DHJoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:44:34 -0400
Date: Mon, 8 Apr 2013 11:44:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robert Richter <rric.net@gmail.com>
Cc: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [GIT PULL] oprofile updates for v3.10
Message-ID: <20130408094430.GA1225@gmail.com>
References: <20130406133959.GA11652@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406133959.GA11652@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <rric.net@gmail.com> wrote:

> Ingo,
> 
> please pull updates for 3.10 (tip/perf/core):
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-tip
> 
> Just one trivial patch.
> 
> Thanks,
> 
> -Robert
> 
> 
> 
> The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:
> 
>   Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git master
> 
> for you to fetch changes up to 23995bbee01d75f09f72b1380bd6045a5b02947b:
> 
>   oprofile, s390: Add support for IBM zEnterprise EC12 (2013-04-06 15:25:42 +0200)
> 
> ----------------------------------------------------------------
> Andreas Krebbel (1):
>       oprofile, s390: Add support for IBM zEnterprise EC12
> 
>  arch/s390/oprofile/init.c | 1 +
>  1 file changed, 1 insertion(+)

Pulled, thanks Robert!

	Ingo
