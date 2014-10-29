Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaJ2SWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:22:39 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:61237 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaJ2SWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:22:38 -0400
Date: Wed, 29 Oct 2014 14:22:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Vikas Shivappa <vikas.shivappa@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141029182234.GA13393@mtj.dyndns.org>
References: <1413485050.28564.14.camel@vshiva-Udesk>
 <20141020161855.GF12020@console-pimps.org>
 <20141024105306.GI12706@worktop.programming.kicks-ass.net>
 <20141028232215.GO12020@console-pimps.org>
 <20141029081640.GT3337@twins.programming.kicks-ass.net>
 <20141029124834.GQ12020@console-pimps.org>
 <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 10:41:47AM -0700, Vikas Shivappa wrote:
> Was wondering if it is a requirement of the 'full hierarchy' for the child
> to inherit the cbm of parent ? .
> Alternately we can allocate the CLOSid when a cgroup is created and have an
> empty cbm - but dont let the tasks to be added unless the user assigns a

Please don't do that.  All controllers must be fully hierarchical,
shouldn't fail task migration and always allow execution of member
tasks.

Thanks.

-- 
tejun
