Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab3HMDOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 23:14:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16904 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab3HMDOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 23:14:47 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=RbvQYlb-YjEA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=aGOhDPDwV-YA:10 a=20KFwNOVAAAA:8 a=WqNgNKsRLQQtvLDEnmsA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 12 Aug 2013 23:14:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] tracing: final fixes for events and some
Message-ID: <20130812231443.52563398@gandalf.local.home>
In-Reply-To: <20130813023922.GA1042@redhat.com>
References: <1375712355.22073.45.camel@gandalf.local.home>
	<20130805143257.GA32639@gmail.com>
	<1375714329.22073.63.camel@gandalf.local.home>
	<20130812181325.GA19405@gmail.com>
	<20130813023922.GA1042@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013 22:39:22 -0400
Dave Jones <davej@redhat.com> wrote:


> I'm not sure why I got cc'd on this, but for my part, the perf/tracing related bugs
> I've found recently may have been there for ages, but they were triggerable
> as non-root users.
> 
>

Which bug was able to trigger with non-root? The hash one that you
reported? That is something with the function tracer. Are you able to
enable function tracing as non-root?

Or is it because you gave more permissions for non-root to use extra
perf commands. Because no one but root should be able to enable
function tracing, as that can add a large overhead to the system.

-- Steve

