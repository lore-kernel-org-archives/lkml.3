Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965857AbaGRPu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:50:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42610 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbaGRPu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:50:58 -0400
Date: Fri, 18 Jul 2014 16:50:13 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Sahasrabudhe, Sheetal" <sheetals@quicinc.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: perf: child events not killed on release paths, survive
 indefinitely
Message-ID: <20140718155013.GA16376@leverpostej>
References: <20140718123238.GF25180@leverpostej>
 <20140718140343.GC20603@laptop.programming.kicks-ass.net>
 <20140718143157.GB17328@leverpostej>
 <20140718144248.GA29768@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718144248.GA29768@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Jiri, could you add me to Cc for future versions of that series?
> > 
> > I'll have a look and see if I can come up with something; otherwise I'm
> > happy to test/review. :)
> 
> sure, and vice versa ;-)

Will do. :)

Mark.
