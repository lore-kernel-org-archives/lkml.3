Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3EVJ16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:27:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38220 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3EVJ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:27:55 -0400
Date: Wed, 22 May 2013 11:27:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, jamie.iles@oracle.com,
        penberg@kernel.org, acme@ghostprotocols.net, paulus@samba.org,
        namhyung@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 8/9] liblockdep: Add the 'lockdep' user-space utility
Message-ID: <20130522092742.GJ18810@twins.programming.kicks-ass.net>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
 <1368674141-10796-9-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368674141-10796-9-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:15:40PM -0400, Sasha Levin wrote:
> This is a simple wrapper to make using liblockdep on existing
> applications much easier.
> 
> After running 'make && make install', it becomes quite simple to
> test things with liblockdep. For example, to try it on perf:
> 
> 	lockdep perf
> 
> No other integration required.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> Cc: jamie.iles@oracle.com
> Cc: penberg@kernel.org
> Cc: acme@ghostprotocols.net
> Cc: paulus@samba.org
> Cc: namhyung@kernel.org
> Cc: peterz@infradead.org
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Link: http://lkml.kernel.org/r/1360456781-32462-11-git-send-email-sasha.levin@oracle.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

I'm listed twice! :-)
