Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaEOPUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:20:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60724 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaEOPUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:20:16 -0400
Date: Thu, 15 May 2014 16:20:11 +0100
From: Javi Merino <javi.merino@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH v3] tracing: Add __bitmask() macro to trace events
 to cpumasks and other bitmasks
Message-ID: <20140515152011.GA12682@e102654-lin.cambridge.arm.com>
References: <20140506132238.22e136d1@gandalf.local.home>
 <484888063.12149.1399403794855.JavaMail.zimbra@efficios.com>
 <20140506231238.246c7d3e@gandalf.local.home>
 <20140514142324.GA10024@e102654-lin.cambridge.arm.com>
 <20140514113623.171f2a39@gandalf.local.home>
 <20140514155053.GB3052@e102654-lin.cambridge.arm.com>
 <20140514142500.020e9896@gandalf.local.home>
 <20140514194241.GA3883@e102654-lin.cambridge.arm.com>
 <20140515073405.11002d59@gandalf.local.home>
 <20140515073609.48049fb0@gandalf.local.home>
MIME-Version: 1.0
In-Reply-To: <20140515073609.48049fb0@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 15 May 2014 15:20:22.0724 (UTC) FILETIME=[309C3840:01CF7051]
X-MC-Unique: 114051516201401501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 12:36:09PM +0100, Steven Rostedt wrote:
> On Thu, 15 May 2014 07:34:05 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> 
> > Should work now. Thanks for testing.
> 
> If all goes well, can you please give me your "Tested-by" for both
> patches. I've already ran my updated bitmask kernel patch through my
> tests (although, there's still no event that uses it).

I've tested it on my setup and it works beautifully now.  You can add
my Tested-by to both the kernel and the trace-cmd patches.  I'll
include the kernel one together with a patch that uses it as part of
our next series, thanks!

> I'll push it to my for-next repo. I'll also work on updating
> libtraceevent with the trace-cmd patch such that perf gets the benefit
> of this new macro as well.

Yup, I guess we'll need a new version of trace-cmd to support this
when it gets into the kernel.

Thanks for the prompt response,
Javi

