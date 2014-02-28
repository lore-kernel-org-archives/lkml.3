Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaB1LXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:23:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaB1LXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:23:00 -0500
Date: Fri, 28 Feb 2014 11:22:56 +0000
From: Mel Gorman <mgorman@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFA][PATCH 2/4] tracing: Fix event header migrate.h to include
 tracepoint.h
Message-ID: <20140228112256.GM6732@suse.de>
References: <20140226190140.590029589@goodmis.org>
 <20140226190644.591040764@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140226190644.591040764@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:01:42PM -0500, Steven Rostedt wrote:
> [ Request for Ack ]
> 
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The trace event headers are required to include tracepoint.h. The only reason
> they worked now is because module.h included tracepoint.h, and that will soon
> change. (And the change will be going to the stable tree as well)
> 
> Fixes: 7b2a2d4a18ff "mm: migrate: Add a tracepoint for migrate_pages"
> Cc: stable@vger.kernel.org # 3.8+
> Cc: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
