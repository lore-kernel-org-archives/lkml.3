Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab3D3Uj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 16:39:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933613Ab3D3Uju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 16:39:50 -0400
Date: Tue, 30 Apr 2013 22:39:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] trivial
In-Reply-To: <alpine.LNX.2.00.1304300953530.20139@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1304302235190.20139@pobox.suse.cz>
References: <alpine.LNX.2.00.1304300953530.20139@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Jiri Kosina wrote:

> please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus
> 
> to receive 3.10 merge window updates from trivial queue.

Unfortunately I made a mistake when merging into for-linus branch, and 
omitted one pre-requisity patch for a few other patches (which have been 
Acked by the appropriate maintainers) in the series. Mea culpa maxima, 
sorry for that.



Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive %pSR format addition, which helps to avoid print_symbol to 
improve readability.

Joe Perches (1):
      vsprintf: Add extension %pSR - print_symbol replacement

 Documentation/printk-formats.txt |    2 ++
 lib/vsprintf.c                   |   18 +++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

-- 
Jiri Kosina
SUSE Labs
