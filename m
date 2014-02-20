Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaBTQ0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:26:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10366 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753683AbaBTQ0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:26:03 -0500
Date: Thu, 20 Feb 2014 11:26:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140220112600.2f44874d@gandalf.local.home>
In-Reply-To: <20140220100830.GN6835@laptop.programming.kicks-ass.net>
References: <20140211132956.GY9987@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
	<20140217152859.GF15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
	<20140219101949.GG15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
	<20140220100830.GN6835@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 11:08:30 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> @rostedt: WTF is disable_trace_on_warning a boot option only?

Laziness.


I'll add a sysctl for it in 3.15.


-- Steve
