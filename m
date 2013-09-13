Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab3IMOcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:32:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab3IMOcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:32:42 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=8G3D-EVed2cA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=znGwHLDW1tUA:10 a=JfrnYn6hAAAA:8 a=vTr9H3xdAAAA:8 a=fBP4x_uF0yMM_F_je9EA:9 a=CjuIK1q_8ugA:10 a=3Rfx1nUSh_UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 13 Sep 2013 10:32:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130913103238.2a88c3e3@gandalf.local.home>
In-Reply-To: <20130913105637.GM31370@twins.programming.kicks-ass.net>
References: <20130911135434.GA678@redhat.com>
	<20130912141913.2ffc7077@gandalf.local.home>
	<20130913105637.GM31370@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013 12:56:37 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Sep 12, 2013 at 02:19:13PM -0400, Steven Rostedt wrote:
> 
> > > The good news is I can reproduce that very quickly.
> > > (Apply http://paste.fedoraproject.org/38721/37890755 on top of trinity.git,
> > >  and run ./trinity -l off -q -C32 -c inotify_init1 -c perf_event_open -c newlstat)
> 
> " The paste you are looking for does not exist "
> 

"These are not the pasties you are looking for"


-- Steve
