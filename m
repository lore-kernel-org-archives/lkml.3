Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbbA2B6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:58:10 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45818 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbbA2B6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:58:08 -0500
Message-ID: <1422446595.5716.34.camel@marge.simpson.net>
Subject: Re: [patch] cpuset: fix crash when adding CPUs to an empty set
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zefan Li <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Wed, 28 Jan 2015 13:03:15 +0100
In-Reply-To: <20150128115332.GD23038@twins.programming.kicks-ass.net>
References: <1421820981.16275.1.camel@marge.simpson.net>
	 <54C84C74.9080102@huawei.com> <1422417235.5716.5.camel@marge.simpson.net>
	 <54C86494.6020509@huawei.com>
	 <20150128115332.GD23038@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 12:53 +0100, Peter Zijlstra wrote: 
> On Wed, Jan 28, 2015 at 12:24:52PM +0800, Zefan Li wrote:
> > > sched: Fix crash if cpuset_cpumask_can_shrink() is passed an empty cpumask
> > > 
> > > While creating an exclusive cpuset, we passed cpuset_cpumask_can_shrink()
> > > an empty cpumask (cur), and dl_bw_of(cpumask_any(cur)) made boom with it.
> > > 
> 
> Is this the case where a new cpuset doesn't yet have CPUs assigned?

Yes.

-Mike


