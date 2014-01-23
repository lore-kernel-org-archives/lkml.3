Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaAWKEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:04:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55957 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaAWKEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:04:39 -0500
Date: Thu, 23 Jan 2014 11:04:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dyoung@redhat.com
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140123100404.GR30183@twins.programming.kicks-ass.net>
References: <52DFD50E.800@oracle.com>
 <20140122183538.GA389@x4>
 <20140122184253.GN30183@twins.programming.kicks-ass.net>
 <20140122190905.GA391@x4>
 <20140122191254.GA390@x4>
 <20140122201605.GU11314@laptop.programming.kicks-ass.net>
 <20140122210814.GC9481@laptop.programming.kicks-ass.net>
 <20140122211740.GA391@x4>
 <20140123094804.GP30183@twins.programming.kicks-ass.net>
 <20140123100100.GA398@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123100100.GA398@x4>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:01:00AM +0100, Markus Trippelsdorf wrote:
> On 2014.01.23 at 10:48 +0100, Peter Zijlstra wrote:
> > On Wed, Jan 22, 2014 at 10:17:40PM +0100, Markus Trippelsdorf wrote:
> > 
> > Ah much simpler patch that should have the same effect:
> 
> Yes. FWIW it also seems to be fine.

Thanks.. the wonders of sleep eh :-)
