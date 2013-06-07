Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3FGXuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:50:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:5003 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213Ab3FGXuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:50:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,825,1363158000"; 
   d="scan'208";a="346610094"
Date: Sat, 8 Jun 2013 07:50:03 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kbuild-all@01.org,
        Christopher Li <sparse@chrisli.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel/workqueue.c:4435:61: sparse: expression using sizeof bool
Message-ID: <20130607235003.GA7234@localhost>
References: <51afd3ac.1kKgJcnM4PAV+Agb%fengguang.wu@intel.com>
 <20130607141521.4000962d5ac0d7fcd54800cf@linux-foundation.org>
 <20130607220351.GE14781@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607220351.GE14781@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:03:51PM -0700, Tejun Heo wrote:
> On Fri, Jun 07, 2013 at 02:15:21PM -0700, Andrew Morton wrote:
> > >   4434		/* copy worker description */
> > > > 4435		probe_kernel_read(&desc_valid, &worker->desc_valid, sizeof(desc_valid));
> > 
> > I don't understand the rationale for the sparse test, really.  This
> > code seems unproblematic.
> 
> Yeah, I've gotten that warning a couple times now and am just ignoring
> it at this point.  Maybe the standard says bool isn't a proper
> integeral type and its size isn't precisely defined or something?  I
> don't know.

Hmm, I'd better disable the warnings that are normally ignored anyway..

Thanks,
Fengguang
