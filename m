Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab3EJLXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:23:17 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:51373 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3EJLXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:23:15 -0400
Date: Fri, 10 May 2013 13:23:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] liblockdep: Support using LD_PRELOAD
Message-ID: <20130510112312.GA19356@gmail.com>
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com>
 <1368115089-8909-8-git-send-email-sasha.levin@oracle.com>
 <20130510111719.GG31235@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510111719.GG31235@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Would something like the below cure things? Obviously this hasn't been 
> near a compiler for the entire thing still isn't wanting to compile for 
> me.

this oneliner command should work it around for you on Quilt:

touch tools/lib/lockdep/uinclude/asm/hweight.h tools/lib/lockdep/uinclude/asm/sections.h tools/lib/lockdep/uinclude/linux/bitops.h tools/lib/lockdep/uinclude/linux/delay.h tools/lib/lockdep/uinclude/linux/ftrace.h tools/lib/lockdep/uinclude/linux/gfp.h tools/lib/lockdep/uinclude/linux/interrupt.h tools/lib/lockdep/uinclude/linux/linkage.h tools/lib/lockdep/uinclude/linux/mm_types.h tools/lib/lockdep/uinclude/linux/mutex.h tools/lib/lockdep/uinclude/linux/proc_fs.h tools/lib/lockdep/uinclude/linux/seq_file.h tools/lib/lockdep/uinclude/linux/system.h tools/lib/lockdep/uinclude/linux/util.h tools/lib/lockdep/uinclude/trace/events/lock.h

Thanks,

	Ingo
