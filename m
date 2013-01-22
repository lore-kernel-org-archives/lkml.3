Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3AVUcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:32:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19241 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3AVUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:32:34 -0500
Date: Tue, 22 Jan 2013 15:32:15 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        js1304@gmail.com, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [RFC PATCH 1/3] staging, zsmalloc: introduce zs_mem_[read/write]
Message-ID: <20130122203215.GB12371@phenom.dumpdata.com>
References: <1358323737-13396-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130116235922.GA18669@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116235922.GA18669@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +EXPORT_SYMBOL_GPL(zs_mem_write);
> 
> Two API have same logic but just different memcpy argument order for input/output
> so you can factor out common logic.

Or have one function but just use an extra argument to define the direction of the
copy.

> 
> Patch looks good to me but I have a concern.
> I'd like to promote zram/zsmalloc as soon as possible.
> My last hurdle was LOCKDEP complaint so I decided to stop sending promoting patches
> until it was solved. At that same time, Nitin was sending some patches on zram meta
> diet and critical bug fix. Of course, they was conflict so we should line patches up
> following as
> 
> 1. Critical bug fix and merge <- merged two days ago.
> 2. Nitin diet patch merge <- pending
> 3. Minchan Lockdep patch merge <- pending
> 
> And then, my plan was trying to promote again.
> But unfortunately, I was not convinced of 2 at that time while we all agree on 3.
> So it takes some time to discuss 2 again and finally merge.
> So I would like to merge lockdep patch as top priority and then,
> Joonsoo/Nitin/Seth could try to send your patches to staging.
> (Seth already had a patch to solve lockdep problem simply in his zswap series
> but I don't like it although I didn't reply his patch.)
> 
> If anyone has objection, please raise your hand.
> I will do best effort to send lockdep patch until early next week.

No objections here.
> 
> -- 
> Kind regards,
> Minchan Kim
