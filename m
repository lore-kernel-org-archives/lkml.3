Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaAVPye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:54:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60793 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaAVPyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:54:31 -0500
Date: Wed, 22 Jan 2014 16:53:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Ballard <dan@mindstab.net>
Cc: Lennart Poettering <lennart@poettering.net>, kay.sievers@vrfy.org,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minto Joseph <mvaliyav@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] add StartTimeMonotomic, StartTimeBootTime to per pid
 in   /proc
Message-ID: <20140122155351.GV13532@twins.programming.kicks-ass.net>
References: <a24256fcec0f1735512ee303ce8abbdc@mindstab.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a24256fcec0f1735512ee303ce8abbdc@mindstab.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 07:10:04AM -0800, Dan Ballard wrote:
> starttime in /proc/$PID/stat is inaccurate by "clock tick" granularity.
> The kernel keeps better track os this exposes that in /prod/$PID/status
> as StartTimeMonotonic and StartTimeBootTime
> 

Why?
