Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936614Ab3DHX4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:56:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936583Ab3DHX4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:56:01 -0400
Date: Mon, 8 Apr 2013 16:55:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH 0/3] posix_timers: A few expiry caching fixes
Message-Id: <20130408165559.f065987fba45a20199a1f74d@linux-foundation.org>
In-Reply-To: <1364649331-30940-1-git-send-email-fweisbec@gmail.com>
References: <1364649331-30940-1-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Mar 2013 14:15:28 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> This series is on top of latest -mmotm.
> 
> [1/3] fixes some omitting sample capture after a build warning suddenly became visible
> [2/3] fixes a wrong timer_gettime() result on a timer whose target has been reaped.
> [3/3] needs some more thinking probably

Nobody seems to have applied these to anything yet.

The changelogs don't have an explicit description of the user-visible
impact of the bugs which were fixed.  Providing such a description
makes it more likely that others will make the correct patch-scheduling
decisions ;)


