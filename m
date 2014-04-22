Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbaDVT6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:58:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaDVT6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:58:48 -0400
Date: Tue, 22 Apr 2014 16:09:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: spinlock trylock failure on UP, i.MX28 3.12.15-rt25
Message-ID: <20140422140918.GE11096@twins.programming.kicks-ass.net>
References: <534C3606.7010206@meduna.org>
 <534C731F.1050406@meduna.org>
 <534DADF1.6060608@meduna.org>
 <20140422115439.GA20669@linutronix.de>
 <20140422094657.5b6ca1e2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422094657.5b6ca1e2@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 09:46:57AM -0400, Steven Rostedt wrote:
> >  According to lockdep a trylock should not fail on UP.

Oh!? Where does it say that? A trylock can fail at all times.
