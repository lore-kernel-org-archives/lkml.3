Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaDVUAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:00:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44436 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbaDVT6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:58:34 -0400
Date: Tue, 22 Apr 2014 13:49:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched / idle: Make cpuidle_idle_call() void
Message-ID: <20140422114930.GH11182@twins.programming.kicks-ass.net>
References: <4717784.WmVEpDoliM@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4717784.WmVEpDoliM@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 01:26:58AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The only value ever returned by cpuidle_idle_call() is 0 and its
> only caller ignores that value anyway, so make it void.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks!
