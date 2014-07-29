Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaG2Qf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:35:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:5183 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbaG2Qf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:35:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,758,1400050800"; 
   d="scan'208";a="550784140"
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
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20140729141908.GA4464@infradead.org>
References: <1406584299.2970.924.camel@schen9-DESK>
	 <20140729141908.GA4464@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jul 2014 09:35:02 -0700
Message-ID: <1406651702.2970.927.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-29 at 07:19 -0700, Christoph Hellwig wrote:
> Hi Tim,
> 
> I think the problem is that sdio.size doesn't get set set with
> the new dio code.  Please try the patch below to fix this by not
> relying on that field:

Thanks for your quick response.  We'll test this patch and let you
know the results.

Tim

