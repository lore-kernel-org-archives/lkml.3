Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab3KRIyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 03:54:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34131 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3KRIyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 03:54:45 -0500
Date: Mon, 18 Nov 2013 09:54:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf sw_event related lockup
Message-ID: <20131118085439.GD3866@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311131739560.5706@vincent-weaver-1.um.maine.edu>
 <20131115145944.GA3694@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1311151223040.11932@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311151223040.11932@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:26:16PM -0500, Vince Weaver wrote:
> On Fri, 15 Nov 2013, Peter Zijlstra wrote:
> > 
> > Please enable CONFIG_FRAME_POINTER to get better backtraces, but the
> > above suggests the pagefault swevent, will have a look.
> 
> here it is again I think.  I compiled with CONFIG_FRAME_POINTER but the 
> backtraces don't look that different.

Looks to be that other one -- the one where the intel constraints thing
goes belly up. I was hoping Stephane would look at that since I know
he's been rewriting that code.
