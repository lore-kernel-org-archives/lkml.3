Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaDCXeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:34:23 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:52243 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbaDCXeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:34:21 -0400
Message-ID: <1396568057.4661.38.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC] mm,tracing: improve current situation
From: Davidlohr Bueso <davidlohr@hp.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 03 Apr 2014 16:34:17 -0700
In-Reply-To: <533DE12C.9030203@intel.com>
References: <1396561440.4661.33.camel@buesod1.americas.hpqcorp.net>
	 <533DE12C.9030203@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 15:31 -0700, Dave Hansen wrote:
> On 04/03/2014 02:44 PM, Davidlohr Bueso wrote:
> > Now, on a more general scenario, I basically would like to know, 1) is
> > this actually useful... I'm hoping that, if in fact something like this
> > gets merged, it won't just sit there. 2) What other general data would
> > be useful for debugging purposes? I'm happy to collect feedback and send
> > out something we can all benefit from.
> 
> One thing that would be nice, specifically for the VM, would be to turn
> all of the things that touch the /proc/vmstat counters
> (count_vm_event(), etc...) in to tracepoints.

Hmm what would be the difference? what's the issue with /proc/vmstat? I
guess for one, some of the stats depend on build rules (ie TLB flushing
statistics).

