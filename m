Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaBXR6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:58:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45808 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaBXR6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:58:46 -0500
Date: Mon, 24 Feb 2014 18:58:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, mingo@kernel.org,
        tglx@linutronix.de, rjw@rjwysocki.net, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] idle: Move idle conditions in cpuidle_idle main
 function
Message-ID: <20140224175838.GF9987@twins.programming.kicks-ass.net>
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
 <1393250151-6982-4-git-send-email-daniel.lezcano@linaro.org>
 <20140224145912.GW27965@twins.programming.kicks-ass.net>
 <530B679C.6070204@linaro.org>
 <20140224160543.GZ9987@twins.programming.kicks-ass.net>
 <530B7B4E.50306@linaro.org>
 <20140224172207.GC9987@twins.programming.kicks-ass.net>
 <alpine.LFD.2.11.1402241242320.17677@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1402241242320.17677@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 12:54:52PM -0500, Nicolas Pitre wrote:
> On Mon, 24 Feb 2014, Peter Zijlstra wrote:
> 
> > Urgh, looks like something went wrong with: cf37b6b48428d 
> > 
> > That commit doesn't actually remove kernel/cpu/idle.c nor is the new
> > code an exact replica of the old one.
> > 
> > Ingo, any chance we can get that fixed?
> 
> The patch I posted was based on v3.13.  It doesn't apply on later 
> kernels without a conflict.  I suspect the conflict resolution was 
> goofed somehow.

Jah, something went bad. I actually remember fixing that patch, but
clearly I must've made a massive fail someplace.
