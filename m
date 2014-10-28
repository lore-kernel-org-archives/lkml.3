Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbaJ1Iay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:30:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaJ1Iaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:30:52 -0400
Date: Tue, 28 Oct 2014 09:30:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 1/5] sched: idle: cpuidle: Check the latency req before
 idle
Message-ID: <20141028083041.GQ3337@twins.programming.kicks-ass.net>
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
 <1777440.htuxA0nWAA@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1777440.htuxA0nWAA@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 11:58:57PM +0100, Rafael J. Wysocki wrote:
> I can apply them unless Peter prefers to take them through sched.  In which
> case Peter please add my ACK to them.

This is mostly cpuidle bits, feel free to take them.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
