Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab3K1PHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:07:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51930 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3K1PHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:07:12 -0500
Date: Thu, 28 Nov 2013 16:07:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128150704.GB10022@twins.programming.kicks-ass.net>
References: <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
 <20131128144359.GL3694@twins.programming.kicks-ass.net>
 <20131128145325.GG3925@htj.dyndns.org>
 <20131128145755.GY10022@twins.programming.kicks-ass.net>
 <20131128150210.GI3925@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128150210.GI3925@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 10:02:10AM -0500, Tejun Heo wrote:
> > So far I just see you breaking existing setups because you don't want to
> > support things that work perfectly well.
> 
> It doesn't work as explained multiple times in this thread.

It used to.. just not on recent kernels. You know 'enterprise' latency.
