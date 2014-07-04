Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaGDES0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 00:18:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49800 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaGDESZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 00:18:25 -0400
Date: Thu, 03 Jul 2014 21:18:20 -0700 (PDT)
Message-Id: <20140703.211820.1674895115102216877.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, akpm@linux-foundation.org,
        tglx@linutronix.de, masami.hiramatsu.pt@hitachi.com, hpa@zytor.com,
        linux-arch@vger.kernel.org, rjw@rjwysocki.net, jkosina@suse.cz,
        notifications@github.com, sparclinux@vger.kernel.org
Subject: Re: [RFA][PATCH 18/27] sparc64,ftrace: Remove check of obsolete
 variable function_trace_stop
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140703124146.3a93668f@gandalf.local.home>
References: <20140626165221.736847419@goodmis.org>
	<20140626165852.160038235@goodmis.org>
	<20140703124146.3a93668f@gandalf.local.home>
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Jul 2014 21:18:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 3 Jul 2014 12:41:46 -0400

> Do you have any problem with this patch going through my tree? It
> compiles, but I do not have any hardware to test it. If you can verify
> that this patch works and ack it, it would be much appreciated.
> 
> This code is at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> 
> branch: rfc/remove-function-trace-stop

I can look at this next week at the earliest.  But frankly I have no problem
if you just merge it as-is now, we can sort out any fallout later.

Thanks.
