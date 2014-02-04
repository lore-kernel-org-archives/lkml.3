Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbaBDUdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:33:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:49255 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaBDUd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:33:28 -0500
Date: Tue, 4 Feb 2014 21:33:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Ballard <dan@mindstab.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Lennart Poettering <lennart@poettering.net>, kay.sievers@vrfy.org,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minto Joseph <mvaliyav@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] v2 add StartTimeMonotomic, StartTimeBootTime to per
 pid in /proc
In-Reply-To: <7a44eaa41ee1e784a52924c595942617@mindstab.net>
Message-ID: <alpine.DEB.2.02.1402042131380.24986@ionos.tec.linutronix.de>
References: <7a44eaa41ee1e784a52924c595942617@mindstab.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014, Dan Ballard wrote:

> starttime in /proc/$PID/stat is inaccurate by "clock tick" granularity.
> The process starttime is useful for a variety of things, like figuring
> out creation ordering of processes and it is useful to detect PID
> reuses in a somewhat reliable way.
> 
> The kernel internally stores finer granularity values and this patch
> exports them in the easily usable location /prod/$PID/status
> as StartTimeMonotonic and StartTimeBootTime.

If you want proper ordered and granular information use tracing.

Thanks,

	tglx


