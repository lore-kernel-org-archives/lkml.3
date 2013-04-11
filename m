Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936367Ab3DKPTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:19:21 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63642 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936188Ab3DKPTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:19:19 -0400
Date: Thu, 11 Apr 2013 17:19:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH 0/3] posix_timers: A few expiry caching fixes
Message-ID: <20130411151913.GE15699@somewhere>
References: <1364649331-30940-1-git-send-email-fweisbec@gmail.com>
 <20130408165559.f065987fba45a20199a1f74d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408165559.f065987fba45a20199a1f74d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 04:55:59PM -0700, Andrew Morton wrote:
> On Sat, 30 Mar 2013 14:15:28 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > This series is on top of latest -mmotm.
> > 
> > [1/3] fixes some omitting sample capture after a build warning suddenly became visible
> > [2/3] fixes a wrong timer_gettime() result on a timer whose target has been reaped.
> > [3/3] needs some more thinking probably
> 
> Nobody seems to have applied these to anything yet.
> 
> The changelogs don't have an explicit description of the user-visible
> impact of the bugs which were fixed.  Providing such a description
> makes it more likely that others will make the correct patch-scheduling
> decisions ;)

Ok, I'll iterate through these and try to get a better description of that side.

Thanks.
