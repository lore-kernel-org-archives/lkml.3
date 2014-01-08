Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbaAHWyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:54:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45436 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550AbaAHWxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:53:41 -0500
Date: Wed, 8 Jan 2014 23:53:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
Message-ID: <20140108225315.GG31570@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 04:28:20PM -0500, Vince Weaver wrote:
> Should the perf_event interface handle setups like this better and work 
> fine in aggregate mode but return ENOTSUP if a sampled or overflow event 
> is attempted?

Yeah that would be better, we do something similar for P6 class machines
without lapic IIRC.
