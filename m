Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3KNRl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:41:57 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:21472 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753555Ab3KNRlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:41:50 -0500
Date: Thu, 14 Nov 2013 12:41:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131114124146.68ad081b@gandalf.local.home>
In-Reply-To: <20131114171405.GA2965@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
	<20131108200244.GB14606@localhost.localdomain>
	<alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
	<20131108204839.GD14606@localhost.localdomain>
	<alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
	<20131108223657.GF14606@localhost.localdomain>
	<20131109151014.GN16117@laptop.programming.kicks-ass.net>
	<20131114152304.GC5364@laptop.programming.kicks-ass.net>
	<alpine.DEB.2.10.1311141217470.8746@vincent-weaver-1.um.maine.edu>
	<20131114171405.GA2965@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013 18:14:05 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

 
> Can't blame you; took me a fair chunk of the day to come up with this.
> That trace event stuff is horrid.

I feel honored ;-)

-- Steve
