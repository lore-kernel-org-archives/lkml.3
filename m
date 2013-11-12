Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab3KLR4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:56:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38196 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3KLR4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:56:11 -0500
Date: Tue, 12 Nov 2013 18:55:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH v2] sched: Check sched_domain before computing group
 power.
Message-ID: <20131112175554.GD21461@twins.programming.kicks-ass.net>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
 <20131112105547.GA27310@linux.vnet.ibm.com>
 <20131112115736.GO5056@laptop.programming.kicks-ass.net>
 <20131112164126.GF2559@linux.vnet.ibm.com>
 <20131112170302.GC16796@laptop.programming.kicks-ass.net>
 <20131112171507.GG2559@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112171507.GG2559@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 10:45:07PM +0530, Srikar Dronamraju wrote:
> > 
> > Hurm.. can you provide the actual topology of the machine that triggers
> > this? My brain hurts trying to thing through the weird cases of this
> > code.
> > 
> 
> Hope this helps. Please do let me know if you were looking for pdf output.

PDFs go into /dev/null..

the below misses the interesting bits; being the node distance table.
Also a complete sched_debug domain print is useful.
