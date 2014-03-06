Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaCFLCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 06:02:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:58811 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751033AbaCFLCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 06:02:18 -0500
Date: Thu, 6 Mar 2014 06:02:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        seiji.aguchi@hds.com, jolsa@redhat.com, vincent.weaver@maine.edu,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, trace: Fix CR2 corruption when tracing
 page faults
Message-ID: <20140306060215.2a78efc2@gandalf.local.home>
In-Reply-To: <20140306084050.GE9987@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu>
	<20140228160526.GD1133@krava.brq.redhat.com>
	<tip-0ac09f9f8cd1fb028a48330edba6023d347d3cea@git.kernel.org>
	<20140305111415.GU9987@twins.programming.kicks-ass.net>
	<20140305072022.6f69f699@gandalf.local.home>
	<20140305122535.GA9987@twins.programming.kicks-ass.net>
	<20140305123635.GP3104@twins.programming.kicks-ass.net>
	<20140305080018.4be698f7@gandalf.local.home>
	<20140305130849.GC9987@twins.programming.kicks-ass.net>
	<53179915.40408@zytor.com>
	<20140306084050.GE9987@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014 09:40:50 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Mar 05, 2014 at 01:37:25PM -0800, H. Peter Anvin wrote:
> 
> > OK, I have to admit to having lost track of this thread.  Please let me
> > know when there is anything actionable for me.
> 
> lkml.kernel.org/r/20140305130749.GR3104@twins.programming.kicks-ass.net
> 
> Was the latest; Rostedt are you good with that one? If so I suppose I
> should make it a proper patch and get hpa to look at it :-)

Yeah, looks good.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
