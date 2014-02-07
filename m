Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaBGCqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 21:46:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:5734 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaBGCqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 21:46:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,797,1384329600"; 
   d="scan'208";a="471156143"
Date: Fri, 7 Feb 2014 10:46:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [slub] WARNING: CPU: 1 PID: 1 at mm/slub.c:992 deactivate_slab()
Message-ID: <20140207024602.GA12062@localhost>
References: <20140205072558.GC9379@localhost>
 <alpine.DEB.2.02.1402050009200.7839@chino.kir.corp.google.com>
 <20140205112449.GB18849@localhost>
 <alpine.DEB.2.02.1402051123520.5616@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1402061340360.12761@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402061340360.12761@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 01:41:10PM -0800, David Rientjes wrote:
> On Wed, 5 Feb 2014, David Rientjes wrote:
> 
> > Ah, that's because the patch didn't go through Pekka's slab tree but went 
> > into -mm instead so we have to wait for another -mm.  However, the traces 
> > from linux-next-20140204 that you provided indicate it's the same problem 
> > and should be fixed with that patch, so let's wait for another mmotm to be 
> > released.
> > 
> 
> Ok, "mm/slub.c: list_lock may not be held in some circumstances" is in 
> linux-next so let me know if this reproduces!

Yeah, linux-next 20140206 no longer has this WARNING!

Thanks,
Fengguang
