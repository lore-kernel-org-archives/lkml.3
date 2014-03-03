Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbaCCVij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:38:39 -0500
Received: from one.firstfloor.org ([193.170.194.197]:54267 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbaCCVih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:38:37 -0500
Date: Mon, 3 Mar 2014 22:38:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Joe Mario <jmario@redhat.com>, Davidlohr Bueso <davidlohr@hp.com>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
Message-ID: <20140303213836.GD22728@two.firstfloor.org>
References: <1393609388-40489-9-git-send-email-dzickus@redhat.com>
 <87lhwvawc4.fsf@tassilo.jf.intel.com>
 <20140228194642.GM25953@redhat.com>
 <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net>
 <20140303150531.GZ25953@redhat.com>
 <20140303172316.GA22728@two.firstfloor.org>
 <5314C4C4.1020304@redhat.com>
 <20140303184117.GL9987@twins.programming.kicks-ass.net>
 <20140303185819.GB22728@two.firstfloor.org>
 <20140303203257.GI25953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303203257.GI25953@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thoughts on how to determine which load is a potential store?  I agree
> every store needs to load the cacheline, but I wasn't sure if there was an
> approach that could be applied to determine anything useful.

HITM covers both load and stores.

But it may have some skid.  The main advantage of the address is that
it is skidless.

-Andi
