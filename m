Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaGaQN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:13:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:35523 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbaGaQNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:13:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,773,1400050800"; 
   d="scan'208";a="551905004"
Subject: Re: [Regression 3.16-rc kernel] -55% reduction in throughput for
 OLTP benchmark
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, suruchi <suruchi.a.kadu@intel.com>,
        ak <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "hubert.nueckel" <hubert.nueckel@intel.com>,
        beth.marsh-prime@intel.com, "doug.nelson" <doug.nelson@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20140730001248.GA32367@infradead.org>
References: <1406584299.2970.924.camel@schen9-DESK>
	 <20140729141908.GA4464@infradead.org>
	 <1406651702.2970.927.camel@schen9-DESK>
	 <20140729164951.GA23863@infradead.org>
	 <1406678232.2970.943.camel@schen9-DESK>
	 <20140730001248.GA32367@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Jul 2014 09:13:50 -0700
Message-ID: <1406823230.2970.946.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-29 at 17:12 -0700, Christoph Hellwig wrote:
> On Tue, Jul 29, 2014 at 04:57:12PM -0700, Tim Chen wrote:
> > Christoph, we're glad to report that this patch does fix the problem.
> > Wonder if Al or someone can pick it up.  It is a large regression
> > that should not be left unfixed for 3.16.
> 
> Al has been away for a bit, and I prepared the last VFS pull.  I'll pick
> it up for now and either Al or I will send it on before next weekend.
> 
> Can I get a tested-by tag from you for the patch?  Can anyone else
> please cross check it?  The new total value might be different from
> the old size value when we do a short write, but I can't see how
> an async write would be a good thing if we had to finish the remainder
> using buffered I/O if the old code really allowed that.
> 

Yes, please put in 

Tested-by: Tim Chen <tim.c.chen@linux.intel.com>
Tested-by: Suruchi Kadu <suruchi.a.kadu@intel.com>

Tim

