Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaDDMwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:52:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53622 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbaDDMwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:52:53 -0400
Date: Fri, 4 Apr 2014 14:52:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix tracepoint in scheduler.
Message-ID: <20140404125249.GC10526@twins.programming.kicks-ass.net>
References: <1396527168-3929-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396527168-3929-1-git-send-email-yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 08:12:48PM +0800, Dongsheng Yang wrote:
> In function set_task_cpu(), if cpu == new_cpu,
> there is no migration happen. But current trace point
> will raise a migration trace event.
> 
> This patch change trace point to right place,
> only when migration really happen, an event will
> be threw out.

Yeah its there so we can see pointless 'migrations'.
