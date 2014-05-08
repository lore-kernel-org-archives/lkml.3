Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaEHHtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:49:35 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63808 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaEHHtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:49:33 -0400
Date: Thu, 8 May 2014 11:49:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>, Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140508074930.GN8607@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506202307.GA1458@moon>
 <20140508020050.GX39568@redhat.com>
 <20140508073756.GM8607@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508073756.GM8607@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 11:37:56AM +0400, Cyrill Gorcunov wrote:
> On Wed, May 07, 2014 at 10:00:50PM -0400, Don Zickus wrote:
> > 
> > I think my commit 13beacee817d27a40ffc6f065ea0042685611dd5 explains this
> > corruption.  Though I have to admit I haven't looked through the problem
> > very closely yet.
> > 
> > IOW my lazy fix in that commit doesn't cover fuzzers and the real problem
> > in p4_pmu_schedule_events. :-)
> 
> Don, Vince, could you please give the patch a run? I've only compile tested
> it obviously since I've no real p4 hw. And the patch itself is a bit ugly
> but should bring the light if we're still having problems in events
> scheduling.

Drop it, won't work.
