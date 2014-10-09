Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaJIJAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:00:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:38501 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaJIJA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:00:26 -0400
Date: Thu, 9 Oct 2014 11:00:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@redhat.com,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        tuukka.tikkanen@linaro.org
Subject: Re: [PATCH RFC 1/2] sched: cfs: introduce capacity_ops
Message-ID: <20141009090024.GR10832@worktop.programming.kicks-ass.net>
References: <20141008060712.4379.42509@quantum>
 <1412749572-29449-1-git-send-email-mturquette@linaro.org>
 <1412749572-29449-2-git-send-email-mturquette@linaro.org>
 <20141008083721.GE10832@worktop.programming.kicks-ass.net>
 <20141008232836.4379.3339@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008232836.4379.3339@quantum>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 04:28:36PM -0700, Mike Turquette wrote:
> > Yeah, like hell no. We do not want modules to affect scheduler
> > behaviour.
> 
> If a CPUfreq driver is the best place to know how frequency affects the
> capacity of a CPU for a given system, are you suggesting that we must
> compile that code into the kernel image instead of it being a loadable
> module?

Ideally we'll end up doing away with the cpufreq policy modules and
integrate the entire thing into the scheduler.
