Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934662AbaJ2R2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:28:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44631 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934214AbaJ2R2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:28:49 -0400
Date: Wed, 29 Oct 2014 18:28:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Auld, Will" <will.auld@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>, Tejun Heo <tj@kernel.org>,
        "Shivappa, Vikas" <vikas.shivappa@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141029172845.GP12706@worktop.programming.kicks-ass.net>
References: <1413485050.28564.14.camel@vshiva-Udesk>
 <20141020161855.GF12020@console-pimps.org>
 <20141024105306.GI12706@worktop.programming.kicks-ass.net>
 <20141028232215.GO12020@console-pimps.org>
 <20141029081640.GT3337@twins.programming.kicks-ass.net>
 <20141029124834.GQ12020@console-pimps.org>
 <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:32:04PM +0000, Auld, Will wrote:
> I maybe repeating what Peter has just said but for elements in the
> hierarchy where the mask is the same as its parents mask there is no
> need for a separate CLOS even in the case where there are tasks in the
> group. So we can inherit the CLOS of the parent until which time both
> the mask is different than the parent and there are tasks in the
> group. 

I did not state that explicitly, but I did think about that. We could
still wait to allocate a CLOS until at least one such group acquires a
task.
