Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaBDIlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:41:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38852 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaBDIkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:40:53 -0500
Date: Tue, 4 Feb 2014 09:39:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, rientjes@google.com, dchinner@redhat.com
Subject: Re: [PATCH v4] oom: add tracepoints for oom_score_adj
Message-ID: <20140204083918.GA31442@dyad.arnhem.chello.nl>
References: <20111207095434.5f2fed4b.kamezawa.hiroyu@jp.fujitsu.com>
 <4EDF99B2.6040007@jp.fujitsu.com>
 <20111208104705.b2e50039.kamezawa.hiroyu@jp.fujitsu.com>
 <20111208153230.9c68eab3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208153230.9c68eab3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 03:32:30PM +0900, KAMEZAWA Hiroyuki wrote:
> From 5dc1f8c879ae424d5853af255df8860494209e39 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Wed, 7 Dec 2011 09:58:16 +0900
> Subject: [PATCH] oom: trace point for oom_score_adj
> 
> oom_score_adj is set to prevent a task from being killed by OOM-Killer.
> Some daemons sets this value and their children inerit it sometimes.
> Because inheritance of oom_score_adj is done automatically, users
> can be confused at seeing the value and finds it's hard to debug.
> 
> This patch adds trace point for oom_score_adj. This adds 3 trace
> points. at
> 	- update oom_score_adj
> 	- fork()
> 	- rename task->comm(typically, exec())
> 

And nobody was bothered by the fact that we already had fork and exec tracepoints?

