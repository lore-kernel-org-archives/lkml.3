Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3HOJJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 05:09:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48147 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3HOJJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 05:09:27 -0400
Date: Thu, 15 Aug 2013 11:09:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: fix cpumask leak in partition_sched_domains
Message-ID: <20130815090916.GL24092@twins.programming.kicks-ass.net>
References: <87d2prqvse.fsf@rustcorp.com.au>
 <1375790802-11857-1-git-send-email-xtfeng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375790802-11857-1-git-send-email-xtfeng@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 08:06:42PM +0800, Xiaotian Feng wrote:
> If doms_new is NULL, partition_sched_domains() will reset ndoms_cur
> to 0, and free old sched domains with free_sched_domains(doms_cur, ndoms_cur).
> As ndoms_cur is 0, the cpumask will not be freed.
> 
> Signed-off-by: Xiaotian Feng <xtfeng@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-kernel@vger.kernel.org

Thanks!
