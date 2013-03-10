Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3CJSg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:36:59 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:56557 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3CJSg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:36:58 -0400
Date: Sun, 10 Mar 2013 11:36:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCH 17/31] workqueue: implement attribute-based unbound
 worker_pool management
Message-ID: <20130310183653.GI24522@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-18-git-send-email-tj@kernel.org>
 <513C5BB9.7030305@cn.fujitsu.com>
 <20130310125821.GG24522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130310125821.GG24522@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 05:58:21AM -0700, Tejun Heo wrote:
> > > +	if (WARN_ON(pool->nr_workers != pool->nr_idle))
> > > +		return;
> > 
> > This can be false-negative. we should remove this WARN_ON().
> 
> How would the test fail spuriously?  Can you please elaborate?

I got it.  It'll be short by one if there's an active manager.
Removed.

Thanks.

-- 
tejun
