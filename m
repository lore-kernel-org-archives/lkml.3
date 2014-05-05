Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbaEESme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:42:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:50005 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751448AbaEESmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:42:33 -0400
Date: Mon, 5 May 2014 14:42:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Bohac <jbohac@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 0/4] Convert timekeeping core to use printk_deferred
 (v2)
Message-ID: <20140505144231.654d85b0@gandalf.local.home>
In-Reply-To: <20140502160536.892e6aff76df3398529d09ad@linux-foundation.org>
References: <1399068558-2373-1-git-send-email-john.stultz@linaro.org>
	<20140502160536.892e6aff76df3398529d09ad@linux-foundation.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014 16:05:36 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

 
> Would "printk_deferred_once" be more logical than
> "printk_once_deferred"?  Think so.  It's (((printk(deferred(once))),
> not (((printk(once(deferred))).
> 

I agree with the above, but other than that you can add my:

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

also, perhaps this series should include my patch:

https://lkml.org/lkml/2014/3/25/336

-- Steve
