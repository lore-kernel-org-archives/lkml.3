Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbaDKMhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:37:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:24583 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754198AbaDKMhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:37:41 -0400
Date: Fri, 11 Apr 2014 08:37:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND 2/2] tracing: syscall_regfunc() should not skip
 kernel threads
Message-ID: <20140411083734.50c953e5@gandalf.local.home>
In-Reply-To: <20140411120347.GA19753@redhat.com>
References: <20140410092842.1f9a8760@gandalf.local.home>
	<20140410133855.GC12228@redhat.com>
	<20140410102816.24337ffe@gandalf.local.home>
	<20140410144655.GA25316@redhat.com>
	<20140410110848.64c3f25e@gandalf.local.home>
	<20140410175705.GB32332@redhat.com>
	<20140410181417.GA2104@redhat.com>
	<20140410151340.7d24aafd@gandalf.local.home>
	<20140410193820.GA15624@redhat.com>
	<20140410155554.44f88536@gandalf.local.home>
	<20140411120347.GA19753@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014 14:03:47 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

 
> I do remember, I already told you are pedant!

Point taken ;-)

I'll pull your patches into my 3.16 queue.

Thanks!

-- Steve

