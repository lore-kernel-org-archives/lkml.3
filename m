Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3IDSV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:21:26 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59504 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3IDSVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:21:24 -0400
Date: Wed, 4 Sep 2013 14:21:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Wu <lekensteyn@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] writeback: fix NULL dereference when device is gone
Message-ID: <20130904182117.GE26609@mtj.dyndns.org>
References: <Pine.LNX.4.44L0.1308172104070.7744-100000@netrider.rowland.org>
 <1755678.6GItDDY0bW@al>
 <20130820133308.GE3926@htj.dyndns.org>
 <2884335.eGSKV8oXr1@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2884335.eGSKV8oXr1@al>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 29, 2013 at 12:31:11AM +0200, Peter Wu wrote:
> I applied your fix in the workfn, but now dd does not stop with EIO. If I run 
> `sync`, then I see:
> 
> [11882.645618] quiet_error: 591905 callbacks suppressed
> [11882.650589] Buffer I/O error on device sdd, logical block 129652880
> [11882.656850] lost page write due to I/O error on sdd
> [11882.661974] Buffer I/O error on device sdd, logical block 129652881
> ...
> 
> Any other ideas? For now I will stick to the original patch. That probably 
> does not solve the root issues, but it is at least a workaround to prevent the 
> machine from locking up.

I'm out of ideas at the moment and maybe we should just stick to your
patch for now.  :(

Thanks.

-- 
tejun
