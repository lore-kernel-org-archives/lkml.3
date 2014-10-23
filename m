Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaJWPAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:00:47 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47308 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaJWPAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:00:42 -0400
Date: Thu, 23 Oct 2014 07:56:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
Message-ID: <20141023145633.GS4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
 <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz>
 <20141022143837.GW4977@linux.vnet.ibm.com>
 <20141022165433.GA22874@linux.vnet.ibm.com>
 <20141022185712.GA9570@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1410222255540.17725@pobox.suse.cz>
 <20141022210943.GL4977@linux.vnet.ibm.com>
 <20141023081125.GA4643@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023081125.GA4643@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102315-0033-0000-0000-000002703243
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:11:25AM +0200, Borislav Petkov wrote:
> On Wed, Oct 22, 2014 at 02:09:43PM -0700, Paul E. McKenney wrote:
> > > Yes, this works. FWIW, please feel free to add 
> > > 
> > > 	Reported-and-tested-by: Jiri Kosina <jkosina@suse.cz>
> > > 
> > > once merging it.
> > 
> > Done, and thank you for both the bug report and the testing!
> 
> Works here too.
> 
> Tested-by: Borislav Petkov <bp@suse.de>

Thank you as well, recorded!

							Thanx, Paul

