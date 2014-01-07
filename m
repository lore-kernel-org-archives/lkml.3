Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaAGKXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:23:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54028 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaAGKXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:23:00 -0500
Date: Tue, 7 Jan 2014 11:22:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Redpath <Chris.Redpath@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 8/8] sched: remove scheduler domain naming
Message-ID: <20140107102242.GQ30183@twins.programming.kicks-ass.net>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
 <1386936688-29113-9-git-send-email-dietmar.eggemann@arm.com>
 <20131220140842.GW16438@laptop.programming.kicks-ass.net>
 <52CAF8D5.7010809@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CAF8D5.7010809@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 06:41:25PM +0000, Dietmar Eggemann wrote:
> But the MC level cpu mask func ptr is called cpu_coregroup_mask.

Nothing a bit of sed won't cure very quickly indeed :-)
