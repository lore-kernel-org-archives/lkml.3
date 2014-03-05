Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaCENJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:09:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51362 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaCENJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:09:02 -0500
Date: Wed, 5 Mar 2014 14:08:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        seiji.aguchi@hds.com, jolsa@redhat.com, vincent.weaver@maine.edu,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, trace: Fix CR2 corruption when tracing
 page faults
Message-ID: <20140305130849.GC9987@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu>
 <20140228160526.GD1133@krava.brq.redhat.com>
 <tip-0ac09f9f8cd1fb028a48330edba6023d347d3cea@git.kernel.org>
 <20140305111415.GU9987@twins.programming.kicks-ass.net>
 <20140305072022.6f69f699@gandalf.local.home>
 <20140305122535.GA9987@twins.programming.kicks-ass.net>
 <20140305123635.GP3104@twins.programming.kicks-ass.net>
 <20140305080018.4be698f7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305080018.4be698f7@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 08:00:18AM -0500, Steven Rostedt wrote:
> >  static void __kprobes
> 
> Still requires the "noinline" above

Trim trim trim trim your emails...

also, you're like 3 version behind.
