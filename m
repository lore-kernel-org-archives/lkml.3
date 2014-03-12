Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaCLP6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:58:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37280 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbaCLP6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:58:18 -0400
Date: Wed, 12 Mar 2014 16:57:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Chinner <david@fromorbit.com>, Waiman Long <waiman.long@hp.com>,
        arnd@arndb.de, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        walken@google.com, andi@firstfloor.org, riel@redhat.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        oleg@redhat.com
Subject: Re: [RFC][PATCH 0/7] locking: qspinlock
Message-ID: <20140312155754.GG27965@twins.programming.kicks-ass.net>
References: <20140310154236.038181843@infradead.org>
 <20140312023153.GW13647@dastard>
 <20140311231159.25a0d8dc@gandalf.local.home>
 <20140312042616.GX13647@dastard>
 <20140312060730.435122f0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312060730.435122f0@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 06:07:30AM -0400, Steven Rostedt wrote:
> On Wed, 12 Mar 2014 15:26:16 +1100
> Dave Chinner <david@fromorbit.com> wrote:
> 
> 
> > I did apply them manually - but the patchset is based on the
> > tip/master, plus some patches from a previous patch set that aren't
> > in tip/locking to be able to apply this patchset cleanly in the
> > first place. So there's no "start froma known working kernel" case
> > that applies here :/
> 
> Peter,
> 
> Which kernel should we start testing your code against?

I build and booted these patches against tip/master as of this morning.
It build ~50 defconfig kernels on my WSM-EP.

I've not managed to reproduce the hang as reported by Dave, but then I
doubt building kernels has anywhere near the lock contention he
generated.

I did run my userspace on both the WSM-EP as well as the Interlagos box,
topping out at 24 and 32 contending cpus resp.

No weird lockups :/
