Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3FEQzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:55:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56619 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3FEQzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:55:07 -0400
Date: Wed, 5 Jun 2013 18:54:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
Message-ID: <20130605165452.GY27176@twins.programming.kicks-ass.net>
References: <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu>
 <20130529074433.GB12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu>
 <20130530072532.GF4341@laptop>
 <alpine.DEB.2.10.1305300842040.11264@vincent-weaver-1.um.maine.edu>
 <20130603132645.GC8923@twins.programming.kicks-ass.net>
 <20130603192505.GH8923@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1306051151570.6484@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306051151570.6484@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 11:54:52AM -0400, Vince Weaver wrote:
> On Mon, 3 Jun 2013, Peter Zijlstra wrote:
> 
> > Seems to cure it... I'm going to let it run over night.
> 
> [sorry for the delay in testing, was at the hospital waiting for
>  a new baby, and the free wi-fi had the ssh port blocked]

Congrats!!
