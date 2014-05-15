Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaEOEuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:50:17 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:42214 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaEOEuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:50:15 -0400
Date: Thu, 15 May 2014 00:50:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Michael Matz <matz@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
Message-ID: <20140515045011.GB3825@htj.dyndns.org>
References: <20140501142414.GA31611@htj.dyndns.org>
 <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz>
 <20140501210242.GA28948@mtj.dyndns.org>
 <20140501210943.GB28948@mtj.dyndns.org>
 <537384B9.5090907@suse.cz>
 <20140514151501.GA24142@suse.cz>
 <20140514163238.GA15690@htj.dyndns.org>
 <1400126037.5175.55.camel@marge.simpson.net>
 <20140515040608.GA3825@htj.dyndns.org>
 <1400129178.5175.82.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400129178.5175.82.camel@marge.simpson.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike.

On Thu, May 15, 2014 at 06:46:18AM +0200, Mike Galbraith wrote:
> > I think it'd be healthier to identify the use cases and then provide
> > proper interface for it.  Note that workqueue can now expose interface
> > to modify concurrency, priority and cpumask to userland which
> > writeback workers are already using.
> 
> You can't identify a specific thing, any/all of it can land on the
> user's diner plate, so he should be able to make the decisions.  Power
> to the user and all that, if he does something stupid, tuff titty.  User
> getting to call the shots, and getting to keep the pieces when he fscks
> it all up is wonderful stuff, lets kernel people off the hook :)

Do we know specific kthreads which need to be exposed with this way?
If there are good enough reasons for specific ones, sure, but I don't
think "we can't change any of the kthreads because someone might be
diddling with it" is something we can sustain in the long term.

Thanks.

-- 
tejun
