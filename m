Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaAFHtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:49:20 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57586 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaAFHtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:49:19 -0500
X-AuditID: 9c93017e-b7cd8ae000002ce9-c1-52ca5ffddeac
Date: Mon, 6 Jan 2014 16:49:28 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [sched] 23f0d2093c: -12.6% regression on sparse file copy
Message-ID: <20140106074928.GB25771@lge.com>
References: <20140105090456.GE28257@localhost>
 <20140106003052.GD696@lge.com>
 <20140106071007.GB23042@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106071007.GB23042@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 03:10:07PM +0800, Fengguang Wu wrote:
> Hi Joonsoo,
> 
> On Mon, Jan 06, 2014 at 09:30:52AM +0900, Joonsoo Kim wrote:
> > On Sun, Jan 05, 2014 at 05:04:56PM +0800, fengguang.wu@intel.com wrote:
> > > Hi Joonsoo,
> > > 
> > > We noticed the below changes for commit 23f0d2093c ("sched: Factor out
> > > code to should_we_balance()") in test vm-scalability/300s-lru-file-readtwice
> > 
> > Hello, Fengguang.
> > 
> > There was a mistake in this patch and there was a fix and it was already merged
> > into mainline.
> > 
> > Could you test again with the commit (b0cff9d sched: Fix load balancing
> > performance regression in should_we_balance())?
> 
> Yes, b0cff9d completely restores the performance. Sorry for the noise!

Thanks for quick response. :)

