Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaKDOEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:04:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:55328 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751841AbaKDOD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:03:59 -0500
Date: Tue, 4 Nov 2014 09:03:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/4 v2] ftracetests: Add ftrace tests to ftracetests
Message-ID: <20141104090357.37531ed3@gandalf.local.home>
In-Reply-To: <54589CBD.8040303@hitachi.com>
References: <20141103212737.696365174@goodmis.org>
	<54589CBD.8040303@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2014 18:30:37 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/11/04 6:27), Steven Rostedt wrote:
> > Second attempt. I took the advice from Masami Hiramatsu and modified
> > my tests. I also added some helper functions to ftracetests as well.
> > 
> > I split the one function graph test into two. One to just test the
> > filtering of the function graph and another to test with stack tracer.
> > 
> > Steven Rostedt (Red Hat) (4):
> >       ftracetest: Add clear_trace() helper to reset the trace file
> >       ftracetest: Add disable/enable_tracing() helper calls
> >       ftracetest: Add helper reset_tracer() function
> 
> BTW, I think you can fold these patches into one. No need to separate
> for each helper functions.

Yeah, I probably should. I did those each at different times, and just
put them in separately.

-- Steve


