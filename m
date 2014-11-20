Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbaKTQK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:10:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbaKTQK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:10:56 -0500
Date: Thu, 20 Nov 2014 17:10:50 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 04/10] writeback: move backing_dev_info->wb_lock and
 ->worklist into bdi_writeback
Message-ID: <20141120161050.GJ2330@quack.suse.cz>
References: <1416299848-22112-1-git-send-email-tj@kernel.org>
 <1416299848-22112-5-git-send-email-tj@kernel.org>
 <20141120160128.GI2330@quack.suse.cz>
 <20141120160249.GH14877@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120160249.GH14877@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-11-14 11:02:49, Tejun Heo wrote:
> On Thu, Nov 20, 2014 at 05:01:28PM +0100, Jan Kara wrote:
> ...
> >   Does this mean you want to have per-device, per-cgroup flusher workqueues?
> > Otherwise this change doesn't make sense...
> 
> Not workqueues but yes separate work items per device-cgroup combo.
> There's no way around it.
  Ah, right. I was confused. So you can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
