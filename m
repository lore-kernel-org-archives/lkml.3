Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaBXRyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:54:55 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:43136 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaBXRyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:54:54 -0500
Date: Mon, 24 Feb 2014 12:54:52 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>, mingo@kernel.org,
        tglx@linutronix.de, rjw@rjwysocki.net, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] idle: Move idle conditions in cpuidle_idle main
 function
In-Reply-To: <20140224172207.GC9987@twins.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.11.1402241242320.17677@knanqh.ubzr>
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org> <1393250151-6982-4-git-send-email-daniel.lezcano@linaro.org> <20140224145912.GW27965@twins.programming.kicks-ass.net> <530B679C.6070204@linaro.org> <20140224160543.GZ9987@twins.programming.kicks-ass.net>
 <530B7B4E.50306@linaro.org> <20140224172207.GC9987@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Peter Zijlstra wrote:

> Urgh, looks like something went wrong with: cf37b6b48428d 
> 
> That commit doesn't actually remove kernel/cpu/idle.c nor is the new
> code an exact replica of the old one.
> 
> Ingo, any chance we can get that fixed?

The patch I posted was based on v3.13.  It doesn't apply on later 
kernels without a conflict.  I suspect the conflict resolution was 
goofed somehow.


Nicolas
