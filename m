Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096Ab3K1PCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:02:15 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:53209 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3K1PCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:02:14 -0500
Date: Thu, 28 Nov 2013 10:02:10 -0500
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128150210.GI3925@htj.dyndns.org>
References: <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
 <20131128144359.GL3694@twins.programming.kicks-ass.net>
 <20131128145325.GG3925@htj.dyndns.org>
 <20131128145755.GY10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128145755.GY10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 03:57:55PM +0100, Peter Zijlstra wrote:
> Do you have a better definition that doesn't get in the way of people
> wanting to do actual work?

As written multiple times now, workqueue does have per-workqueue
attributes and if you really want a dedicated worker thread, use a
dedicated kthread.

> So far I just see you breaking existing setups because you don't want to
> support things that work perfectly well.

It doesn't work as explained multiple times in this thread.

-- 
tejun
