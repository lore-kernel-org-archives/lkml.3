Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaAMNqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:46:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:14909 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaAMNqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:46:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="457906569"
Date: Mon, 13 Jan 2014 21:46:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, Dave Hansen <dave@sr71.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] re-shrink 'struct page' when SLUB is on.
Message-ID: <20140113134609.GB31640@localhost>
References: <20140103180147.6566F7C1@viggo.jf.intel.com>
 <20140103141816.20ef2a24c8adffae040e53dc@linux-foundation.org>
 <20140106043237.GE696@lge.com>
 <52D05D90.3060809@sr71.net>
 <20140110153913.844e84755256afd271371493@linux-foundation.org>
 <52D0854F.5060102@sr71.net>
 <CAOJsxLE-oMpV2G-gxrhyv0Au1tPd87Ow57VD5CWFo41wF8F4Yw@mail.gmail.com>
 <alpine.DEB.2.10.1401111854580.6036@nuc>
 <20140113014408.GA25900@lge.com>
 <1389584218.11984.0.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389584218.11984.0.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So, I think
> > that it is better to get more benchmark results to this patchset for convincing
> > ourselves. If possible, how about asking Fengguang to run whole set of
> > his benchmarks before going forward?
> 
> Cc'ing him.

My pleasure. Is there a git tree for the patches? Git trees
are most convenient for running automated tests and bisects.

Thanks,
Fengguang
