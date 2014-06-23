Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaFWObR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:31:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:56492 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753890AbaFWObO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:31:14 -0400
Date: Mon, 23 Jun 2014 10:31:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Max Asbock <masbock@linux.vnet.ibm.com>, mingo@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] tracing: tell mm_migrate_pages event about
 numa_misplaced
Message-ID: <20140623103111.00197f5d@gandalf.local.home>
In-Reply-To: <20140623142159.GP10819@suse.de>
References: <1403290156.4484.10.camel@oc3432500282.ibm.com>
	<20140623142159.GP10819@suse.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014 15:21:59 +0100
Mel Gorman <mgorman@suse.de> wrote:

> On Fri, Jun 20, 2014 at 11:49:16AM -0700, Max Asbock wrote:
> > 
> > The mm_migrate_pages trace event reports a reason for the migration, typically as a
> > symbolic string. The exception is the reason MR_NUMA_MISPLACED for which it just displays
> > the numeric value:
> > mm_migrate_pages: nr_succeeded=1 nr_failed=0 mode=MIGRATE_ASYNC reason=0x5
> > 
> > This patch makes the output consistent by introducing a string value for MR_NUMA_MISPLACED.
> > The event is then reported as:
> > mm_migrate_pages: nr_succeeded=1 nr_failed=0 mode=MIGRATE_ASYNC reason=numa_misplaced
> > 
> > Signed-off-by: Max Asbock <masbock@linux.vnet.ibm.com>
> 
> Acked-by: Mel Gorman <mgorman@suse.de>
> 

Would you like to take this? Or Andrew?

You can add my Acked-by: Steven Rostedt <rostedt@goodmis.org>


-- Steve
