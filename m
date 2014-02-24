Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaBXPAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:00:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39861 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaBXPAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:00:11 -0500
Date: Mon, 24 Feb 2014 16:00:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/5] idle/cpuidle: Split cpuidle_idle_call main
 function into smaller functions
Message-ID: <20140224150004.GX27965@twins.programming.kicks-ass.net>
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



None of this actually applies :/ I'm having major conflicts in
driveres/cpuidle/cpuidle.c.
