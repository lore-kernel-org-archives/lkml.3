Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab3BWBgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 20:36:01 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:63520 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3BWBf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 20:35:58 -0500
Date: Fri, 22 Feb 2013 17:35:54 -0800
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: [idr/perf_init_event] BUG: unable to handle kernel NULL pointer
 dereference at (null)
Message-ID: <20130223013554.GS3570@htj.dyndns.org>
References: <20130223013011.GA9484@localhost>
 <20130223013448.GR3570@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130223013448.GR3570@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 05:34:48PM -0800, Tejun Heo wrote:
> Hello,
> 
> On Sat, Feb 23, 2013 at 09:30:11AM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > commit f5947173c082a04a9804bb42a91a0f5df5ee0527
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Wed Feb 20 02:05:52 2013 +0000
> > 
> >     idr: implement lookup hint
> 
> Andy Shevchenko already posted fix two days ago.  Let me check whether
> that went in yet.

Yeah, already in -mm.  It's titled "idr: always do slow path when hint
is uninitialized".

Thanks

-- 
tejun
