Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaBECvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 21:51:53 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:62668 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751523AbaBECvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 21:51:52 -0500
Date: Tue, 4 Feb 2014 21:51:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Smith <dsmith@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Igor Zhbanov <i.zhbanov@samsung.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] exec: Fix use after free of tracepoint
 trace_sched_process_exec
Message-ID: <20140204215149.7a81e9bc@gandalf.local.home>
In-Reply-To: <20140204213109.40dcfd28@gandalf.local.home>
References: <20140204120500.041b5175@gandalf.local.home>
	<CA+55aFyObrVGXqncNboMzybeevPBOtAUcn-zur_B26VHJ1CEcg@mail.gmail.com>
	<20140204182852.43ffa442@gandalf.local.home>
	<20140204184208.6f4f22a8@gandalf.local.home>
	<CA+55aFyTC1UGvRgH5vASh-C3M+GqHPMNGsUq3Q1MuynzkiSaEA@mail.gmail.com>
	<20140204213109.40dcfd28@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014 21:31:09 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
 
> (probably should keep)
> 
> Reported-by: Igor Zhbanov <i.zhbanov@samsung.com>

I should probably state that "IZh" confirmed on IRC that this is indeed
the person that reported the issue in the first place.

-- Steve
