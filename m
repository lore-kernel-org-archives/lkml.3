Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaCCRXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:23:18 -0500
Received: from one.firstfloor.org ([193.170.194.197]:53290 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaCCRXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:23:17 -0500
Date: Mon, 3 Mar 2014 18:23:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Andi Kleen <andi@firstfloor.org>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
Message-ID: <20140303172316.GA22728@two.firstfloor.org>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-9-git-send-email-dzickus@redhat.com>
 <87lhwvawc4.fsf@tassilo.jf.intel.com>
 <20140228194642.GM25953@redhat.com>
 <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net>
 <20140303150531.GZ25953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303150531.GZ25953@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, so based on Andi's reply, I am assuming you are running on a Westmere
> (or Nehalem) due to the lack of mem-stores.
> 
> If you don't have mem-stores, this tool isn't going to work.  The tool can
> only detect contention when sampling reads _and_ writes to the same
> addresses.

On these CPUs you could simply sample on HITM. You won't get addresses,
but at least IPs and call stacks.

-Andi
