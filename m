Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaIBNmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:42:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbaIBNmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:42:11 -0400
Date: Tue, 2 Sep 2014 09:41:39 -0400
From: Dave Jones <davej@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Catalin Iacob <iacobcatalin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: nohz fail (was: perf related boot hang.)
Message-ID: <20140902134139.GA6579@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Catalin Iacob <iacobcatalin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140811200931.GA18865@redhat.com>
 <1408566691-3023-1-git-send-email-iacobcatalin@gmail.com>
 <CAFTL4hxJ2roTB3tZBmXU3HRetgFSUT0LNVWfX-Y2hbpyXSo2pg@mail.gmail.com>
 <CAHg_5gq1XiZ1A08PtQ7Rof3rUXJ-pVYkXtmHqgFh6hB+++qPNg@mail.gmail.com>
 <20140822140009.GA8567@redhat.com>
 <20140901201429.GA1586@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901201429.GA1586@lerouge>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 10:14:31PM +0200, Frederic Weisbecker wrote:
 > On Fri, Aug 22, 2014 at 10:00:09AM -0400, Dave Jones wrote:
 > > On Fri, Aug 22, 2014 at 08:01:48AM +0200, Catalin Iacob wrote:
 > >  > On Thu, Aug 21, 2014 at 4:56 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
 > >  > > Can you please test the series I just posted: "[RFC PATCH 0/9] nohz:
 > >  > > Nohz full kick fixes"?
 > >  > 
 > >  > Before applying the series I tried one more Firefox build which
 > >  > triggered the panic after less than 5 minutes.
 > >  > 
 > >  > After applying the series I did 2 full builds (around 60 minutes in
 > >  > total) with no problem.
 > > 
 > > Seems to be working fine here too after fuzzing for 17 hours so far.
 > 
 > Thanks a lot for testing this guys!
 > 
 > I'll send "nohz: Restore NMI safe local irq work for local nohz kick"
 > as a fix for 3.17 and the rest will have to wait for 3.18 as it's a complicated
 > fix for a long standing bug.
 > 
 > Can I apply your Tested-by from you both?

Sure, I haven't seen any recurrance of this since applying your patches.

	Dave


