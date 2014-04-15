Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaDOOSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:18:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbaDOOSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:18:37 -0400
Date: Tue, 15 Apr 2014 10:18:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Message-ID: <20140415141826.GB17018@redhat.com>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415140650.GI1863@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:06:50AM -0400, Tejun Heo wrote:

[..]
> But then do we name other stat knobs similarly too?
> 
>  blkio.cfq.io_service_sectors
>  blkio.cfq.io_service_bytes
>  blkio.cfq.io_serviced
>  blkio.cfq.io_merged
> 
> I don't know.  The names look outright stupid to me.  If we don't do
> the above, then we have internal inconsistencies among cfq knob names
> which gotta be worse then cfq / throttl inconsistency.  It's not a
> perfect situation no matter what we do.  As long as each knob is
> clearly documented, I don't think these inconsistencies are big deal,
> so let's just clean up cfq names as we need to add prefix anyway.

Ok, that's fine. Let us just document the knobs well so that people can
find which knob is giving what information and make cfq names better at
the expense of inconsistency of names with throttling layer.

Thanks
Vivek
