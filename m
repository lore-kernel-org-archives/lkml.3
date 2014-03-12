Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbaCLCPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 22:15:01 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54192 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaCLCPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 22:15:00 -0400
Date: Wed, 12 Mar 2014 03:14:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/6] cputime: Fix nsecs_to_cputime() return type cast
Message-ID: <20140312021453.GA26283@localhost.localdomain>
References: <1394128601-26034-1-git-send-email-fweisbec@gmail.com>
 <1394128601-26034-2-git-send-email-fweisbec@gmail.com>
 <5318C50D.2010505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5318C50D.2010505@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 01:57:17PM -0500, Rik van Riel wrote:
> On 03/06/2014 12:56 PM, Frederic Weisbecker wrote:
> >Even though nsec based cputime_t maps to u64, nsecs_to_cputime() must
> >return a cputime_t value. We want to enforce this kind of cast in order
> >to track down buggy manipulations of cputime_t such as direct access
> >of its values under wrong assumptions on its backend type (nsecs,
> >jiffies, etc...) by core code.
> >
> >Cc: Ingo Molnar <mingo@kernel.org>
> >Cc: Marcelo Tosatti <mtosatti@redhat.com>
> >Cc: Peter Zijlstra <peterz@infradead.org>
> >Cc: Thomas Gleixner <tglx@linutronix.de>
> >Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Acked-by: Rik van Riel <riel@redhat.com>
> 

Thanks a lot for your acks. I added them for the pull request.
Unfortunately git-send-email ignored them for the Cc (it seems to
depend on the version).

But the pull request can be found there: http://marc.info/?i=1394590202-772-1-git-send-email-fweisbec%40gmail.com
