Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaCLJZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:25:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51163 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbaCLJZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:25:42 -0400
Date: Wed, 12 Mar 2014 10:25:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: is printk() safe within a timekeeper_seq write section?
Message-ID: <20140312092536.GO30956@twins.programming.kicks-ass.net>
References: <20140306174531.GA30634@midget.suse.cz>
 <531F6429.8050008@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531F6429.8050008@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 12:29:45PM -0700, John Stultz wrote:
> So I don't think I've seen anything like the above in my testing, but it
> may just be very hard to get that path to trigger.

You have to explicitly enable HRTICK for this to be possible; its
disabled by default.
