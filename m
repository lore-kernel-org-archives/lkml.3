Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbaD1TYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:24:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58070 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbaD1TYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:24:47 -0400
Date: Mon, 28 Apr 2014 20:31:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: lockdep warning after recent cleanup in console code
Message-ID: <20140428183107.GE17778@laptop.programming.kicks-ass.net>
References: <1398702925.11914.292.camel@smile.fi.intel.com>
 <20140428134331.68771bf7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428134331.68771bf7@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 01:43:31PM -0400, Steven Rostedt wrote:
> 
> Peter,
> 
> Things have changed with regard to printk() in linux-next. Now it
> appears that lockdep is going haywire over it. I don't understand the
> exact reason for the lockdep_off() and lockdep_on() logic that is in
> printk(), but it obviously seems to be causing issues with the new
> changes.
> 
> Care to take a look?

https://lkml.org/lkml/2011/6/21/247


