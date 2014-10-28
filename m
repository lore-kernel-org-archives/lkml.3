Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaJ1XWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:22:20 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40923 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaJ1XWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:22:19 -0400
Date: Tue, 28 Oct 2014 23:22:15 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Will Auld <will.auld@intel.com>, Tejun Heo <tj@kernel.org>,
        Vikas Shivappa <vikas.shivappa@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141028232215.GO12020@console-pimps.org>
References: <1413485050.28564.14.camel@vshiva-Udesk>
 <20141020161855.GF12020@console-pimps.org>
 <20141024105306.GI12706@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024105306.GI12706@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct, at 12:53:06PM, Peter Zijlstra wrote:
> 
> NAK, cgroups must support full hierarchies, simply enforce that the
> child cgroup's mask is a subset of the parent's.

For the specific case of Cache Allocation, if we're creating hierarchies
from bitmasks, there's a very clear limit to how we can divide up the
bits - we can't support an indefinite number of cgroup directories.

What do you mean by "full hierarchies"?

-- 
Matt Fleming, Intel Open Source Technology Center
