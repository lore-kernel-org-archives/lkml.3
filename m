Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaAPO0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:26:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38703 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaAPO0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:26:06 -0500
Date: Thu, 16 Jan 2014 15:25:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
Message-ID: <20140116142546.GU31570@twins.programming.kicks-ass.net>
References: <52D64676.4040000@linaro.org>
 <20140115120418.GD31570@twins.programming.kicks-ass.net>
 <52D7E343.40909@linaro.org>
 <20140116141743.GT31570@twins.programming.kicks-ass.net>
 <52D7EAA4.2080208@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D7EAA4.2080208@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 03:20:20PM +0100, Daniel Lezcano wrote:
> Already tested. The last commits do not change the issue described above.

Bummer, ok, what version of Ubuntu/rsyslogd are you using? I have a
laptop around that should have some recent ubuntu on it, let me go find
it.
