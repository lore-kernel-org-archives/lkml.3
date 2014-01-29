Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaA2IOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:14:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:25934 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbaA2IN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:13:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,740,1384329600"; 
   d="scan'208";a="466453595"
Date: Wed, 29 Jan 2014 16:13:52 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, pshelar@nicira.com
Subject: Re: [PATCH] mm: slub: fix page->_count corruption (again)
Message-ID: <20140129081352.GA20914@localhost>
References: <20140128231722.E7387E6B@viggo.jf.intel.com>
 <20140128152956.d5659f56ae279856731a1ac5@linux-foundation.org>
 <52E842CF.7090102@sr71.net>
 <20140129064350.GA20252@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129064350.GA20252@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > Fengguang, could you run a set of tests for the top patch in this branch
> > to see if we'd be giving much up by axing the code?
> > 
> > 	https://github.com/hansendc/linux/tree/slub-nocmpxchg-for-Fengguang-20140128
> 
> Sure, I've queued tests for the branch. Will report back after 1-2
> days.

btw, just a tip, it would normally cost half time if the branch is
based directly on a mainline (RC) release, eg. v3.13, v3.13-rcX.
Because to evaluate a branch, we need to test&compare its BASE and
HEAD. If the BASE is v3.* kernels, the test infrastructure will very
likely have tested it.

Thanks,
Fengguang
