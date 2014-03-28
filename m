Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaC1HF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:05:27 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50408 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaC1HFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:05:25 -0400
Message-ID: <1395990322.4877.22.camel@marge.simpson.net>
Subject: Re: [RFC II] Splitting scheduler into two halves
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "morten.rasmussen@arm.com" <morten.rasmussen@arm.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Cox, Alan" <alan.cox@intel.com>
Date: Fri, 28 Mar 2014 08:05:22 +0100
In-Reply-To: <20140327230022.GA27225@intel.com>
References: <20140326183721.GC24116@intel.com>
	 <1395896233.5512.45.camel@marge.simpson.net>
	 <20140327072511.GA2555@gmail.com> <20140327221320.GA26843@intel.com>
	 <1395989431.4877.19.camel@marge.simpson.net>
	 <20140327230022.GA27225@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 07:00 +0800, Yuyang Du wrote: 
> On Fri, Mar 28, 2014 at 07:50:31AM +0100, Mike Galbraith wrote:
> > On Fri, 2014-03-28 at 06:13 +0800, Yuyang Du wrote:
> > 
> > > Spitting does feel brutal...
> > 
> > FWIW, "split" stuck hard in my gullet because task placement is core
> 
> Oh, sorry for that, :)

It wasn't _painful_ or anything, I just couldn't swallow it ;-)

> > fastpath mission.  If the fastpath could afford to and did task
> > placement perfectly, task placement EDC (if you will) mechanisms would
> > not exist.
> 
> Sometimes, we have to if not get to.

Yup... but it's still core mission.

