Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaKKVaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:30:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:43400 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751702AbaKKVaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:30:39 -0500
Date: Tue, 11 Nov 2014 16:30:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] mm/page-writeback.c: divide by zero in pos_ratio_polynom
 not fixed
Message-ID: <20141111163029.5d356716@gandalf.local.home>
In-Reply-To: <20141111211615.GE32298@quack.suse.cz>
References: <20141101082325.7be0463f@gandalf.local.home>
	<20141111201539.GA12333@quack.suse.cz>
	<20141111160448.61354836@gandalf.local.home>
	<20141111211615.GE32298@quack.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014 22:16:15 +0100
Jan Kara <jack@suse.cz> wrote:


>   BTW, how much memory does the machine have and what is
> /proc/sys/vm/dirty_ratio and /proc/sys/vm/dirty_background_ratio (or
> corresponding dirty_bytes, dirty_background_bytes if you are using them)?
> 
> 								Honza

It's currently booted in my x86_64 kernel (I use this box to test both
32bit and 64bit kernels). Also, note, this box recently went though a
new motherboard upgrade, which added 4 gigs more of memory, bringing it
to a total of 8gigs, which probably explains some things.

I wouldn't normally run such a box with a 32bit kernel.

I'll have to wait a bit before I can boot back to the 32bit kernel to
get the rest of that info for you.

-- Steve
