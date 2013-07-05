Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab3GEKXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:23:09 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:38321 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab3GEKXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:23:07 -0400
Date: Fri, 5 Jul 2013 12:23:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Ellerman <michael@ellerman.id.au>, Vince Weaver <vince@deater.net>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, vincent.weaver@maine.edu,
        Stephane Eranian <eranian@google.com>, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for perf
Message-ID: <20130705102302.GA10227@gmail.com>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
 <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy>
 <20130704125218.GA21134@concordia>
 <20130704125700.GM18898@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704125700.GM18898@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jul 04, 2013 at 10:52:18PM +1000, Michael Ellerman wrote:
> > I don't think it even needs libpfm4, just some csv files in tools/perf
> > would do the trick.
> 
> Right; I think Stephane and Jiri are in favour of creating a 'new' 
> project that includes just the event definitions in a plain text format 
> and a little library with parser to be used by all interested parties.

I'd be fine with that if it's stuck somewhere into tools/lib/ or so.

Thanks,

	Ingo
