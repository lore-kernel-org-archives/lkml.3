Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaB0QCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:02:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:30102 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752129AbaB0QCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:02:50 -0500
Date: Thu, 27 Feb 2014 11:02:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?UTF-8?B?TWzDoWRlaw==?= <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [RFA][PATCH 1/5] ftrace/x86: Run a sync after fixup on failure
Message-ID: <20140227110244.69e643e6@gandalf.local.home>
In-Reply-To: <20140227155811.GE22707@pathway.suse.cz>
References: <20140227154616.703252665@goodmis.org>
	<20140227154922.957070805@goodmis.org>
	<20140227155811.GE22707@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 16:58:12 +0100

> > Reported-by: Petr Mladek <pmladek@suse.cz>
> 
> Tested-by: Petr Mladek <pmladek@suse.cz>

Thanks, I'll update my commit log.

-- Steve


