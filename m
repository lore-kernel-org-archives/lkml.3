Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971AbbAFWhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:37:38 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:44622 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbAFWhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:37:37 -0500
Date: Tue, 6 Jan 2015 17:37:34 -0500
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH block/for-next 2/4] blkcg: add blkcg_root_css
Message-ID: <20150106223734.GB24106@htj.dyndns.org>
References: <20141117211321.GD23126@htj.dyndns.org>
 <20141117211357.GE23126@htj.dyndns.org>
 <20141120201609.GE6999@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120201609.GE6999@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 03:16:09PM -0500, Vivek Goyal wrote:
> On Mon, Nov 17, 2014 at 04:13:57PM -0500, Tejun Heo wrote:
> [..]
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -1408,6 +1408,9 @@ int kblockd_schedule_delayed_work(struct
> >  int kblockd_schedule_delayed_work_on(int cpu, struct delayed_work *dwork, unsigned long delay);
> >  
> >  #ifdef CONFIG_BLK_CGROUP
> > +
> > +extern struct cgroup_subsys_state * const blkcg_root_css;
> 
> Hi Tejun,
> 
> Would it make sense to keep this in include/linux/blk-cgroup.h

Moved in the new version which just got posted.

Thanks.

-- 
tejun
