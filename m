Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaBYKFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:05:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36420 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaBYKFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:05:40 -0500
Date: Tue, 25 Feb 2014 11:05:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
Message-ID: <20140225100510.GH9987@twins.programming.kicks-ass.net>
References: <20140207140536.943daf965008b9428cdcb468@linux-foundation.org>
 <201402081055.BGJ73403.tQMLFVOJSOOFFH@I-love.SAKURA.ne.jp>
 <20140207180647.5944fe3d.akpm@linux-foundation.org>
 <201402092327.JAD12489.QOLSFVMHJtFOOF@I-love.SAKURA.ne.jp>
 <201402102243.IEJ52676.JOFVMOQFOFSLtH@I-love.SAKURA.ne.jp>
 <201402172027.BFH81210.FJtOQOMLHFSVOF@I-love.SAKURA.ne.jp>
 <530BF6B4.3040206@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530BF6B4.3040206@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 09:49:40AM +0800, Lai Jiangshan wrote:
> >>From ada6c4d94f5afda36c7c21869d38b7111a6fe9bc Mon Sep 17 00:00:00 2001
> > From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Date: Mon, 17 Feb 2014 14:32:11 +0900
> > Subject: [PATCH] Change task_struct->comm to use RCU.
> > 
> > This patch changes task_struct->comm to be updated using RCU
> > (unless memory allocation fails).

This Changelog sucks; it fails to describe a problem; therefore there is
no fix and the patch goes away, *poof*.
