Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaAXH6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 02:58:45 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46977 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaAXH6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 02:58:43 -0500
Date: Fri, 24 Jan 2014 08:58:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Dave Young <dyoung@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140124075839.GB30158@gmail.com>
References: <20140122183538.GA389@x4>
 <20140122184253.GN30183@twins.programming.kicks-ass.net>
 <20140122190905.GA391@x4>
 <20140122191254.GA390@x4>
 <20140122201605.GU11314@laptop.programming.kicks-ass.net>
 <20140122210814.GC9481@laptop.programming.kicks-ass.net>
 <20140123015354.GB3768@dhcp-16-126.nay.redhat.com>
 <20140123021028.GE3768@dhcp-16-126.nay.redhat.com>
 <20140123165655.GY31570@twins.programming.kicks-ass.net>
 <20140124031551.GC4922@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124031551.GC4922@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Young <dyoung@redhat.com> wrote:

> On 01/23/14 at 05:56pm, Peter Zijlstra wrote:
> > On Thu, Jan 23, 2014 at 10:10:28AM +0800, Dave Young wrote:
> > > Hmm, seems the my physical machine is booting fine with this patch. kvm
> > > guest problem still exist, but that kvm thing might be other problem.
> > 
> > Dave, could you try with tip/master, Ingo pushed out all the fixes
> > gathered.
> 
> tip/master works fine for me.

Ok, thanks for testing - I'll send those bits to Linus later today.

Thanks,

	Ingo
