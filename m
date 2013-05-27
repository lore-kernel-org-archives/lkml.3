Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3E0CEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:04:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab3E0CEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:04:40 -0400
Date: Mon, 27 May 2013 11:04:59 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] ipc/sem.c: Bug fixes, regression fixes, v3
Message-ID: <20130527020459.GA7365@kroah.com>
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 11:08:51AM +0200, Manfred Spraul wrote:
> I've split my patch into 4 parts:
> - 1: Fix-missing-wakeups-in-do_smart_update
> - 2: seperate-wait-for-zero-and-alter-tasks
> - 3: Always-use-only-one-queue-for-alter-operations
> - 4: Rename-try_atomic_semop-to-perform_atomic
> 
> Linus:
> - Patch 1 should be merged immediately: It fixes bugs,
>   the current code misses wakeups.

Should this patch be backported to 3.9 and maybe older kernels as well?

thanks,

greg k-h
