Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaENUAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:00:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:36408 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750705AbaENUAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:00:17 -0400
Date: Wed, 14 May 2014 16:00:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH v3] tracing: Add __bitmask() macro to trace events
 to cpumasks and other bitmasks
Message-ID: <20140514160015.74c84dc3@gandalf.local.home>
In-Reply-To: <20140514194241.GA3883@e102654-lin.cambridge.arm.com>
References: <1399377998-14870-1-git-send-email-javi.merino@arm.com>
	<1399377998-14870-6-git-send-email-javi.merino@arm.com>
	<20140506132238.22e136d1@gandalf.local.home>
	<484888063.12149.1399403794855.JavaMail.zimbra@efficios.com>
	<20140506231238.246c7d3e@gandalf.local.home>
	<20140514142324.GA10024@e102654-lin.cambridge.arm.com>
	<20140514113623.171f2a39@gandalf.local.home>
	<20140514155053.GB3052@e102654-lin.cambridge.arm.com>
	<20140514142500.020e9896@gandalf.local.home>
	<20140514194241.GA3883@e102654-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 20:42:41 +0100
Javi Merino <javi.merino@arm.com> wrote:

> On Wed, May 14, 2014 at 07:25:00PM +0100, Steven Rostedt wrote:
> > Updated version.
> > 
> > You can test it with the attached trace-cmd patch. I tested it against
> > big and little endian machines (each reading their own and the other
> > machine's trace.dat file). I did not test against 32bit, but it should
> > still work. I will test it before I commit it to traceevent library.
> > 
> > Can you review this and try it out?
> 
> I've tested it in a 32-bit system.  It generates the data and it's
> able to read its own trace.dat fine.  However, If I read the
> trace.dat on a 64-bit machine I get a random character at the
> end of the mask:
> 

Can you send me your trace.dat file privately. Also, please compress it
with either gzip, bzip or xz.

Thanks!

-- Steve

