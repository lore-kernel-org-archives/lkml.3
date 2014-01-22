Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaAVVRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:17:44 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:54588 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaAVVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:17:43 -0500
Date: Wed, 22 Jan 2014 22:17:40 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20140122211740.GA391@x4>
References: <20140122122609.GA392@x4>
 <20140122123022.GN31570@twins.programming.kicks-ass.net>
 <20140122131456.GA389@x4>
 <52DFD50E.800@oracle.com>
 <20140122183538.GA389@x4>
 <20140122184253.GN30183@twins.programming.kicks-ass.net>
 <20140122190905.GA391@x4>
 <20140122191254.GA390@x4>
 <20140122201605.GU11314@laptop.programming.kicks-ass.net>
 <20140122210814.GC9481@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122210814.GC9481@laptop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.01.22 at 22:08 +0100, Peter Zijlstra wrote:
> > 
> > I think its the right region to look through. My current suspect is the
> > linear continuity fit with the initial 'random' multiplier.
> > 
> > That initial 'random' multiplier can get us quite high, and we'll fit
> > the function to match that but continue at a sane rate.
> > 
> > I'll try and prod a little more later this evening as time permits.
> 
> Does this cure things?

Yes. Thanks Peter.

-- 
Markus
