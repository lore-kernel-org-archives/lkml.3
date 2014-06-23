Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaFWOWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:22:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbaFWOWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:22:03 -0400
Date: Mon, 23 Jun 2014 15:21:59 +0100
From: Mel Gorman <mgorman@suse.de>
To: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch] tracing: tell mm_migrate_pages event about numa_misplaced
Message-ID: <20140623142159.GP10819@suse.de>
References: <1403290156.4484.10.camel@oc3432500282.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1403290156.4484.10.camel@oc3432500282.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:49:16AM -0700, Max Asbock wrote:
> 
> The mm_migrate_pages trace event reports a reason for the migration, typically as a
> symbolic string. The exception is the reason MR_NUMA_MISPLACED for which it just displays
> the numeric value:
> mm_migrate_pages: nr_succeeded=1 nr_failed=0 mode=MIGRATE_ASYNC reason=0x5
> 
> This patch makes the output consistent by introducing a string value for MR_NUMA_MISPLACED.
> The event is then reported as:
> mm_migrate_pages: nr_succeeded=1 nr_failed=0 mode=MIGRATE_ASYNC reason=numa_misplaced
> 
> Signed-off-by: Max Asbock <masbock@linux.vnet.ibm.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
