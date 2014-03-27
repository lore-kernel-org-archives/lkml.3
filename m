Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaC1G7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 02:59:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:41351 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaC1G7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 02:59:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,749,1389772800"; 
   d="scan'208";a="481949491"
Date: Fri, 28 Mar 2014 07:00:22 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
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
Subject: Re: [RFC II] Splitting scheduler into two halves
Message-ID: <20140327230022.GA27225@intel.com>
References: <20140326183721.GC24116@intel.com>
 <1395896233.5512.45.camel@marge.simpson.net>
 <20140327072511.GA2555@gmail.com>
 <20140327221320.GA26843@intel.com>
 <1395989431.4877.19.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395989431.4877.19.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 07:50:31AM +0100, Mike Galbraith wrote:
> On Fri, 2014-03-28 at 06:13 +0800, Yuyang Du wrote:
> 
> > Spitting does feel brutal...
> 
> FWIW, "split" stuck hard in my gullet because task placement is core

Oh, sorry for that, :)

> fastpath mission.  If the fastpath could afford to and did task
> placement perfectly, task placement EDC (if you will) mechanisms would
> not exist.

Sometimes, we have to if not get to.

Yuyang
