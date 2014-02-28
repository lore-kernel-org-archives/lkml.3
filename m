Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaB1M4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:56:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55290 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaB1M4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:56:11 -0500
Date: Fri, 28 Feb 2014 13:56:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/5] idle/cpuidle: Split cpuidle_idle_call main
 function into smaller functions
Message-ID: <20140228125604.GN27965@twins.programming.kicks-ass.net>
References: <1393315733-32321-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393315733-32321-1-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Daniel; can you rebase these patches on top of tip/master.

Ingo is going to create tip/sched/idle := tip/sched/core +
tip/timer/core and then we can stick these patches in there.
