Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaEOLgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:36:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:55847 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751480AbaEOLgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:36:11 -0400
Date: Thu, 15 May 2014 07:36:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Javi Merino <javi.merino@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH v3] tracing: Add __bitmask() macro to trace events
 to cpumasks and other bitmasks
Message-ID: <20140515073609.48049fb0@gandalf.local.home>
In-Reply-To: <20140515073405.11002d59@gandalf.local.home>
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
	<20140515073405.11002d59@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 07:34:05 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> Should work now. Thanks for testing.

If all goes well, can you please give me your "Tested-by" for both
patches. I've already ran my updated bitmask kernel patch through my
tests (although, there's still no event that uses it).

I'll push it to my for-next repo. I'll also work on updating
libtraceevent with the trace-cmd patch such that perf gets the benefit
of this new macro as well.

-- Steve
