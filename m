Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3E0T5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 15:57:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab3E0T5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 15:57:19 -0400
Date: Tue, 28 May 2013 04:57:32 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] ipc/sem.c: Bug fixes, regression fixes, v3
Message-ID: <20130527195732.GB5295@kroah.com>
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
 <20130527020459.GA7365@kroah.com>
 <51A39CEE.9030303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A39CEE.9030303@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 01:50:38PM -0400, Rik van Riel wrote:
> On 05/26/2013 10:04 PM, Greg KH wrote:
> >On Sun, May 26, 2013 at 11:08:51AM +0200, Manfred Spraul wrote:
> >>I've split my patch into 4 parts:
> >>- 1: Fix-missing-wakeups-in-do_smart_update
> >>- 2: seperate-wait-for-zero-and-alter-tasks
> >>- 3: Always-use-only-one-queue-for-alter-operations
> >>- 4: Rename-try_atomic_semop-to-perform_atomic
> >>
> >>Linus:
> >>- Patch 1 should be merged immediately: It fixes bugs,
> >>   the current code misses wakeups.
> >
> >Should this patch be backported to 3.9 and maybe older kernels as well?
> 
> No need, the new semaphore code (with this last regression)
> did not get merged until the 3.10 merge window.

Thanks, I didn't realize that.

greg k-h
