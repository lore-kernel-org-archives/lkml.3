Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaEaVSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 17:18:13 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42325 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaEaVSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 17:18:12 -0400
Date: Sat, 31 May 2014 14:16:55 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Vlastimil Babka <vbabka@suse.cz>
cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: sleeping function warning from __put_anon_vma
In-Reply-To: <538A43E0.5070706@suse.cz>
Message-ID: <alpine.LSU.2.11.1405311411420.1125@eggly.anvils>
References: <20140530000944.GA29942@redhat.com> <alpine.LSU.2.11.1405311321340.10272@eggly.anvils> <538A43E0.5070706@suse.cz>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014, Vlastimil Babka wrote:
> On 05/31/2014 10:33 PM, Hugh Dickins wrote:
> > On Thu, 29 May 2014, Dave Jones wrote:
> > 
> >> BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:47
> >> in_atomic(): 0, irqs_disabled(): 0, pid: 5787, name: trinity-c27
> >> Preemption disabled at:[<ffffffff990acc7e>] vtime_account_system+0x1e/0x50
> 
> Just wondering, since I'm not familiar with this kind of bug, is the line above
> bogus or what does it mean? I don't see how the stack trace or the fix patch is
> related to vtime_account_system?

I know no more about it than you do, never noticed such a message before,
and clearly not helpful here.  I expect it's like those "last sysfs file"
messages, occasionally useful but mostly noise.

Hugh
